import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../model/map_relation.dart';

/// 관계 지도 — 가운데에 나, 주변에 상대들(SPEC-0030 관계 지도).
///
/// **가운데에 가까울수록 겹치는 곳이 많다.** 거리를 겹침의 세기로 읽게 해서,
/// 숫자를 하나하나 비교하지 않아도 누구와 가장 통하는지 한눈에 보이게 한다.
///
/// 거리는 겹친 **수**가 아니라 [MapRelation.overlapRatio](상대가 다녀온 곳 중
/// 나와 겹치는 비율)로 정한다. 수만 쓰면 많이 다닌 사람이 무조건 가까워져
/// "취향이 비슷하다"는 뜻이 흐려진다.
///
/// **사람 수에 따라 배치가 달라진다.** 한 겹으로만 돌리면 적을 때는 휑하고
/// 많을 때는 이름표가 겹친다 — 한 겹에 담을 수 있는 수를 넘으면 바깥 겹을
/// 만들고, 겹마다 시작 각도를 틀어 서로 어긋나게 놓는다.
class RelationOrbit extends StatelessWidget {
  const RelationOrbit({
    required this.relations,
    required this.meLabel,
    this.onTap,
    super.key,
  });

  final List<MapRelation> relations;

  /// 가운데 원에 쓸 말("나").
  final String meLabel;

  final void Function(MapRelation relation)? onTap;

  /// 한 겹에 놓을 수 있는 최대 인원. 넘으면 겹을 하나 더 만든다.
  static const int _perRing = 8;

  /// 가장 안쪽 궤도가 바깥 궤도의 몇 배인지.
  ///
  /// 바깥쪽 반지름은 비율로 두지 않는다 — 화면에서 원과 이름표가 차지하는 실제
  /// 크기를 빼고 남는 만큼이 최대다. 비율로 두면 사람이 늘 때 밖으로 삐져나간다
  /// (8명에서 1개, 50명에서 16개가 나갔다 — 위젯 테스트로 확인).
  static const double _innerRingScale = 0.35;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    // 사람이 늘수록 겹이 늘고, 겹이 늘수록 원을 줄여 서로 붙지 않게 한다.
    final int ringCount = (relations.length / _perRing).ceil().clamp(1, 4);
    final double meDiameter = switch (relations.length) {
      <= 3 => 84.0,
      <= 12 => 72.0,
      _ => 60.0,
    };
    final double peerDiameter = switch (relations.length) {
      <= 3 => 64.0,
      <= 12 => 52.0,
      <= 24 => 44.0,
      _ => 36.0,
    };
    // 사람이 많으면 이름을 다 쓸 수 없다 — 원 안의 숫자만 남긴다.
    final bool showNames = relations.length <= 12;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double w = constraints.maxWidth;
        final double h = constraints.maxHeight;
        final Offset center = Offset(w / 2, h / 2);

        // **원과 이름표가 차지하는 만큼을 빼고 남는 것이 최대 반지름이다.**
        // 이름표는 원보다 넓고(+34) 아래로 더 내려가므로 세로 여유가 더 든다.
        final double halfBubble = peerDiameter / 2;
        final double labelWidth = showNames ? (peerDiameter + 34) / 2 : 0;
        final double labelHeight = showNames ? 18 : 0;
        final double maxRadius = math.max(
          0,
          math.min(
            w / 2 - math.max(halfBubble, labelWidth) - 4,
            h / 2 - halfBubble - labelHeight - 4,
          ),
        );

        final List<_Placed> placed = _place(
          center: center,
          maxRadius: maxRadius,
          ringCount: ringCount,
        );

        return Stack(
          children: <Widget>[
            // 배경: 은은한 방사 그라데이션. 가운데가 밝아 시선이 나에게 모인다.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.75,
                    colors: <Color>[
                      scheme.primary.withValues(alpha: 0.07),
                      scheme.surface.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),

            // 궤도선과 연결선. 한 번의 CustomPaint로 모아 그린다 — 위젯마다
            // Positioned.fill을 겹치면 사람 수만큼 레이어가 쌓인다.
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _WebPainter(
                    center: center,
                    placed: placed,
                    ringRadii: <double>[
                      for (int i = 0; i < ringCount; i++)
                        _radiusOfRing(i, ringCount, maxRadius),
                    ],
                    orbitColor: scheme.outlineVariant.withValues(alpha: 0.45),
                    linkColor: scheme.primary,
                  ),
                ),
              ),
            ),

            for (final _Placed p in placed)
              Positioned(
                left: p.at.dx - peerDiameter / 2,
                top: p.at.dy - peerDiameter / 2,
                child: GestureDetector(
                  onTap: onTap == null ? null : () => onTap!(p.relation),
                  child: _PeerBubble(
                    diameter: peerDiameter,
                    relation: p.relation,
                    showName: showNames,
                  ),
                ),
              ),

            // 나는 맨 위에. 상대가 겹쳐도 가려지지 않는다.
            Positioned(
              left: center.dx - meDiameter / 2,
              top: center.dy - meDiameter / 2,
              child: _MeBubble(diameter: meDiameter, label: meLabel),
            ),
          ],
        );
      },
    );
  }

  /// 겹 번호로 반지름을 정한다. 겹이 하나면 [maxRadius]에 붙인다.
  double _radiusOfRing(int ring, int ringCount, double maxRadius) {
    final double minRadius = maxRadius * _innerRingScale;
    if (ringCount == 1) return maxRadius;
    final double t = ring / (ringCount - 1);
    return minRadius + (maxRadius - minRadius) * t;
  }

  /// 사람들을 겹에 나눠 배치한다.
  ///
  /// 겹침이 많은 사람이 앞에 오도록 이미 정렬돼 들어오므로, 안쪽 겹부터 채우면
  /// 자연히 가까운 사람이 안쪽에 놓인다.
  List<_Placed> _place({
    required Offset center,
    required double maxRadius,
    required int ringCount,
  }) {
    final List<_Placed> out = <_Placed>[];

    for (int i = 0; i < relations.length; i++) {
      final int ring = (i ~/ _perRing).clamp(0, ringCount - 1);
      final int indexInRing = i % _perRing;

      // 이 겹에 실제로 몇 명이 있는지 — 마지막 겹은 덜 찰 수 있다.
      final int startOfRing = ring * _perRing;
      final int countInRing = math.min(
        _perRing,
        relations.length - startOfRing,
      );

      // 겹마다 시작 각도를 틀어 안쪽·바깥쪽이 일직선으로 겹치지 않게 한다.
      final double ringOffset = ring * (math.pi / _perRing);
      final double angle =
          -math.pi / 2 +
          ringOffset +
          (2 * math.pi * indexInRing) / math.max(countInRing, 1);

      final double radius = _radiusOfRing(ring, ringCount, maxRadius);
      out.add(
        _Placed(
          relation: relations[i],
          at: center + Offset(math.cos(angle), math.sin(angle)) * radius,
        ),
      );
    }
    return out;
  }
}

/// 배치가 끝난 한 사람.
class _Placed {
  const _Placed({required this.relation, required this.at});

  final MapRelation relation;
  final Offset at;
}

/// 가운데의 나.
class _MeBubble extends StatelessWidget {
  const _MeBubble({required this.diameter, required this.label});

  final double diameter;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Container(
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            scheme.primary,
            Color.lerp(scheme.primary, Colors.black, 0.18)!,
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.30),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          color: scheme.onPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// 상대 한 명. 원 안에 겹친 수, 아래에 닉네임.
class _PeerBubble extends StatelessWidget {
  const _PeerBubble({
    required this.diameter,
    required this.relation,
    required this.showName,
  });

  final double diameter;
  final MapRelation relation;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    // 겹칠수록 진하다 — 거리에 더해 색으로도 세기를 읽게 한다.
    final double t = relation.overlapRatio.clamp(0.0, 1.0);
    final Color fill = Color.lerp(
      scheme.secondaryContainer,
      scheme.primary,
      0.15 + 0.65 * t,
    )!;
    final Color text = t > 0.45 ? scheme.onPrimary : scheme.onSecondaryContainer;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: diameter,
          height: diameter,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: Border.all(
              color: scheme.surface.withValues(alpha: 0.9),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${relation.overlappingCount}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: text,
              fontWeight: FontWeight.w700,
              fontSize: diameter * 0.34,
            ),
          ),
        ),
        if (showName) ...<Widget>[
          const SizedBox(height: 4),
          SizedBox(
            width: diameter + 34,
            child: Text(
              relation.nickname,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// 궤도선과 연결선을 한 번에 그린다.
class _WebPainter extends CustomPainter {
  const _WebPainter({
    required this.center,
    required this.placed,
    required this.ringRadii,
    required this.orbitColor,
    required this.linkColor,
  });

  final Offset center;
  final List<_Placed> placed;
  final List<double> ringRadii;
  final Color orbitColor;
  final Color linkColor;

  @override
  void paint(Canvas canvas, Size size) {
    // 궤도선은 점선으로 — 실선은 표처럼 딱딱해 보인다.
    final Paint orbit = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = true
      ..color = orbitColor;
    for (final double r in ringRadii) {
      _dashedCircle(canvas, center, r, orbit);
    }

    // 연결선. 겹칠수록 진하고 굵다.
    for (final _Placed p in placed) {
      final double t = p.relation.overlapRatio.clamp(0.0, 1.0);
      canvas.drawLine(
        center,
        p.at,
        Paint()
          ..strokeWidth = 1 + 1.6 * t
          ..isAntiAlias = true
          ..color = linkColor.withValues(alpha: 0.12 + 0.38 * t),
      );
    }
  }

  /// 점선 원. `dashPath` 패키지 없이 호를 끊어 그린다.
  void _dashedCircle(Canvas canvas, Offset c, double r, Paint paint) {
    if (r <= 0) return;
    const double dash = 0.06; // 라디안
    const double gap = 0.04;
    final Rect rect = Rect.fromCircle(center: c, radius: r);
    for (double a = 0; a < 2 * math.pi; a += dash + gap) {
      canvas.drawArc(rect, a, dash, false, paint);
    }
  }

  @override
  bool shouldRepaint(_WebPainter old) =>
      old.center != center ||
      old.placed != placed ||
      old.ringRadii != ringRadii ||
      old.orbitColor != orbitColor ||
      old.linkColor != linkColor;
}
