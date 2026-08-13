// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viewer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 지금 로그인한 사용자를 **작성자 표현으로** 옮긴 값. 로그인하지 않았으면 null이다.
///
/// **왜 필요한가.** `ConversationController.send`는 낙관적 말풍선을 그리려고 발신자
/// 정보를 요구한다 — 서버 응답이 오기 전에 아바타·닉네임을 그려야 하기 때문이다.
/// 그 값의 출처는 세션 하나뿐이라 화면마다 세션을 파헤치는 대신 여기서 한 번 옮긴다.
///
/// DM 재진입 아이콘의 표시 여부도 이 값으로 가른다 — 로그인하지 않았으면 눌러도
/// 갈 곳이 없다(디자인 §1.5).
///
/// **`domain/auth` 의존은 기능 간 import가 아니라 세션 의존이다.** 세션은 특정 기능이
/// 아니라 앱 전체의 상태이며, `domain/settings`가 이미 같은 방식으로 읽는다.

@ProviderFor(viewerAuthor)
const viewerAuthorProvider = ViewerAuthorProvider._();

/// 지금 로그인한 사용자를 **작성자 표현으로** 옮긴 값. 로그인하지 않았으면 null이다.
///
/// **왜 필요한가.** `ConversationController.send`는 낙관적 말풍선을 그리려고 발신자
/// 정보를 요구한다 — 서버 응답이 오기 전에 아바타·닉네임을 그려야 하기 때문이다.
/// 그 값의 출처는 세션 하나뿐이라 화면마다 세션을 파헤치는 대신 여기서 한 번 옮긴다.
///
/// DM 재진입 아이콘의 표시 여부도 이 값으로 가른다 — 로그인하지 않았으면 눌러도
/// 갈 곳이 없다(디자인 §1.5).
///
/// **`domain/auth` 의존은 기능 간 import가 아니라 세션 의존이다.** 세션은 특정 기능이
/// 아니라 앱 전체의 상태이며, `domain/settings`가 이미 같은 방식으로 읽는다.

final class ViewerAuthorProvider
    extends $FunctionalProvider<PostAuthor?, PostAuthor?, PostAuthor?>
    with $Provider<PostAuthor?> {
  /// 지금 로그인한 사용자를 **작성자 표현으로** 옮긴 값. 로그인하지 않았으면 null이다.
  ///
  /// **왜 필요한가.** `ConversationController.send`는 낙관적 말풍선을 그리려고 발신자
  /// 정보를 요구한다 — 서버 응답이 오기 전에 아바타·닉네임을 그려야 하기 때문이다.
  /// 그 값의 출처는 세션 하나뿐이라 화면마다 세션을 파헤치는 대신 여기서 한 번 옮긴다.
  ///
  /// DM 재진입 아이콘의 표시 여부도 이 값으로 가른다 — 로그인하지 않았으면 눌러도
  /// 갈 곳이 없다(디자인 §1.5).
  ///
  /// **`domain/auth` 의존은 기능 간 import가 아니라 세션 의존이다.** 세션은 특정 기능이
  /// 아니라 앱 전체의 상태이며, `domain/settings`가 이미 같은 방식으로 읽는다.
  const ViewerAuthorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'viewerAuthorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$viewerAuthorHash();

  @$internal
  @override
  $ProviderElement<PostAuthor?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PostAuthor? create(Ref ref) {
    return viewerAuthor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostAuthor? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostAuthor?>(value),
    );
  }
}

String _$viewerAuthorHash() => r'acb1731579b158db94a52a6db90adb678598bd24';
