# SPEC-0014 — 카카오 지도 SDK는 코드 축소·난독화·최적화 대상에서 제외한다.
# SDK가 네이티브 레이어에서 리플렉션으로 클래스를 찾기 때문에, 난독화되면 지도가
# 뜨지 않거나 오버레이가 사라진다(kakao_map_sdk README 1-2).
-keep class com.kakao.vectormap.** { *; }
-keep interface com.kakao.vectormap.**

# 현재 release 빌드는 `minifyEnabled`를 켜지 않아 이 파일이 적용되지 않는다.
# 난독화를 켜는 시점에 build.gradle.kts의 release 블록에서 연결해야 한다:
#
#   release {
#       isMinifyEnabled = true
#       proguardFiles(
#           getDefaultProguardFile("proguard-android-optimize.txt"),
#           "proguard-rules.pro",
#       )
#   }
#
# 규칙을 미리 두는 이유는, 난독화를 켜는 사람이 지도 SDK의 요구사항까지 함께
# 기억해야 하는 상황을 만들지 않기 위해서다.
