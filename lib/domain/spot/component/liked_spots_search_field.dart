import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../provider/liked_spots_providers.dart';

/// 좋아요 목록 내 검색 입력(SPEC-0033 §입력 처리).
///
/// **입력이 멎은 뒤 조회한다** — 타자 한 글자마다 목록을 갈아 끼우면 호출량도 늘고
/// 화면이 깜빡인다. 대기 시간은 [likedSpotsSearchDebounce]다.
///
/// 타이핑 중 문자열은 이 위젯의 [TextEditingController]가, 조회를 트리거하는 확정
/// 값은 `likedSpotsSearchQueryProvider`가 들고 있다 — 둘을 하나로 두면 입력할 때마다
/// 재조회가 걸린다(`SearchScreen`의 `_typed`와 같은 갈래다).
///
/// `SearchScreen`의 입력창과 **시각적으로 같게** 맞춘다(§13) — 사용자에게 두 검색이
/// 다른 물건으로 보일 이유가 없다. 다만 최근 검색어 패널·자동완성은 가져오지
/// 않는다(스펙 §3 비범위).
class LikedSpotsSearchField extends ConsumerStatefulWidget {
  const LikedSpotsSearchField({super.key});

  @override
  ConsumerState<LikedSpotsSearchField> createState() =>
      _LikedSpotsSearchFieldState();
}

class _LikedSpotsSearchFieldState extends ConsumerState<LikedSpotsSearchField> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // 상세에 다녀오는 것은 탭 이탈이 아니므로 검색어가 살아 있다 — 입력창도 그것을
    // 그대로 들고 있어야 어긋나 보이지 않는다.
    _controller = TextEditingController(
      text: ref.read(likedSpotsSearchQueryProvider),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// 입력이 멎으면 검색어를 확정한다. 다음 글자가 들어오면 앞선 타이머를 버린다.
  void _onChanged(String value) {
    // 지우기는 기다릴 이유가 없다 — 빈 입력은 "필터 없음"이라 서버를 부르는 비용이
    // 검색어를 치는 경우와 다르고, 결과 없음 화면에서 곧바로 목록이 돌아와야 한다.
    if (value.trim().isEmpty) {
      _debounce?.cancel();
      ref.read(likedSpotsSearchQueryProvider.notifier).clear();
      setState(() {});
      return;
    }
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(likedSpotsSearchDebounce, () {
      _debounce = null;
      ref.read(likedSpotsSearchQueryProvider.notifier).set(value);
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    ref.read(likedSpotsSearchQueryProvider.notifier).clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    // 탭을 떠나면 화면이 검색어를 버린다 — 입력창도 함께 비워 다음 진입이 빈
    // 입력으로 시작하게 한다(§입력 처리).
    //
    // 콜백은 빌드 중에 불릴 수 있으므로 `setState`를 한 프레임 뒤로 미룬다 —
    // 빌드 중 `setState`는 프레임워크가 막는다.
    ref.listen<String>(likedSpotsSearchQueryProvider, (String? _, String next) {
      if (next.isNotEmpty || _controller.text.isEmpty) return;
      _debounce?.cancel();
      _controller.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: TextField(
        key: const Key('liked_spots_search_field'),
        controller: _controller,
        textInputAction: TextInputAction.search,
        // **상한을 입력에서 막는다**(§입력 처리) — `QUERY_TOO_LONG`은 방어선이지
        // 정상 경로가 아니다. 카운터는 띄우지 않는다(100자에 닿을 일이 드물다).
        maxLength: likedSpotsQueryMaxLength,
        buildCounter:
            (
              _, {
              required int currentLength,
              required int? maxLength,
              required bool isFocused,
            }) => null,
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(likedSpotsQueryMaxLength),
        ],
        decoration: InputDecoration(
          hintText: l10n.likedSpotsSearchHint,
          prefixIcon: const Icon(Icons.search),
          // 지우는 수단을 둔다 — 결과 없음 상태에서 특히 필요하다(§입력 처리).
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  key: const Key('liked_spots_search_clear'),
                  tooltip: l10n.likedSpotsSearchClear,
                  icon: const Icon(Icons.clear),
                  onPressed: _clear,
                ),
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: _onChanged,
        // 제출은 디바운스를 앞당길 뿐 다른 동작이 아니다.
        onSubmitted: (String value) {
          _debounce?.cancel();
          ref.read(likedSpotsSearchQueryProvider.notifier).set(value);
        },
      ),
    );
  }
}
