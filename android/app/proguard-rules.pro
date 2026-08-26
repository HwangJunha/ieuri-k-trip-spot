# SPEC-0014 — 카카오 지도 SDK는 코드 축소·난독화·최적화 대상에서 제외한다.
# SDK가 네이티브 레이어에서 리플렉션으로 클래스를 찾기 때문에, 난독화되면 지도가
# 뜨지 않거나 오버레이가 사라진다(kakao_map_sdk README 1-2).
-keep class com.kakao.vectormap.** { *; }
-keep interface com.kakao.vectormap.**

# **2026-08-26부터 실제로 적용된다** — release에서 `isMinifyEnabled`와
# `isShrinkResources`를 켰다(사용자 결정). 위 카카오 규칙이 없으면 지도가 뜨지
# 않으므로 함께 확인해야 한다.
#
# 난독화된 크래시 로그를 되돌리려면 매핑 파일을 Play에 올린다:
#   build/app/outputs/mapping/prodRelease/mapping.txt
