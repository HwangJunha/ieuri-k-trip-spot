import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../provider/liked_spots_providers.dart';

/// 좋아요 목록 내 검색 입력(SPEC-0033 §입력 처리).
///
/// **엔터(제출)로만 조회한다**(사용자 결정, 2026-08-29). 타자 중에는 아무 요청도
/// 나가지 않는다 — 전체 코퍼스 검색(`SearchScreen`)이 이미 제출로 실행되므로 두
/// 검색의 조작이 같아지고, 목록이 타자 중에 갈아 끼워지지 않는다.
///
/// 예전에는 입력이 멎으면 자동 조회했는데(디바운스 300ms), 그러면 **엔터가 듣지
/// 않는 것처럼 보였다** — 타이머가 이미 같은 검색어를 확정해 둬서 엔터를 쳐도
/// provider 상태가 그대로였고, family 키가 안 바뀌니 재조회도 없었다.
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
    _controller.dispose();
    super.dispose();
  }

  /// 타이핑은 **조회하지 않는다.** 지우기 버튼을 띄울지만 다시 그린다.
  ///
  /// 입력을 다 지우면 그때만 검색어를 버려 전체 목록으로 돌아간다 — 지우는 것은
  /// 검색의 취소이지 새 조회가 아니라, 엔터를 한 번 더 치게 할 이유가 없다.
  void _onChanged(String value) {
    if (value.trim().isEmpty) {
      ref.read(likedSpotsSearchQueryProvider.notifier).clear();
    }
    setState(() {});
  }

  /// 엔터(제출)로 조회한다.
  ///
  /// **같은 검색어로 다시 제출하면 아무 일도 일어나지 않는다** — provider 상태가
  /// 그대로라 family 키가 바뀌지 않기 때문이다. 이미 그 결과를 보고 있으므로
  /// 맞는 동작이고, 조회가 실패했다면 목록의 재시도 버튼이 그 자리를 맡는다.
  void _submit(String value) =>
      ref.read(likedSpotsSearchQueryProvider.notifier).set(value);

  void _clear() {
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
        // **조회를 일으키는 유일한 자리다.**
        onSubmitted: _submit,
      ),
    );
  }
}
