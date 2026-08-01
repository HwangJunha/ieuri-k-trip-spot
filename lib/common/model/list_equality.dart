/// 두 리스트의 원소별 동등성 비교. 값 기반 `==`/`hashCode`를 구현하는 도메인
/// 모델들이 공유한다(CursorPage·SwipeQueue 등). 순수 Dart — 외부 의존 없음.
///
/// 순서까지 포함해 같은 길이·같은 원소면 true. 원소 비교는 각 원소의 `==`를 쓴다.
bool listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
