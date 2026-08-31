# SPEC-0014 — 카카오 지도 SDK는 코드 축소·난독화·최적화 대상에서 제외한다.
# SDK가 네이티브 레이어에서 리플렉션으로 클래스를 찾기 때문에, 난독화되면 지도가
# 뜨지 않거나 오버레이가 사라진다(kakao_map_sdk README 1-2).
-keep class com.kakao.vectormap.** { *; }
-keep interface com.kakao.vectormap.**

# 카카오 SDK 전반(로그인·공유 등)도 리플렉션으로 모델을 역직렬화한다. 지도만
# 지켜서는 로그인 흐름이 난독화에 깨진다.
-keep class com.kakao.sdk.** { *; }
-keep interface com.kakao.sdk.**

# Firebase는 `ComponentDiscovery`가 매니페스트에 적힌 Registrar 클래스 이름을
# 읽어 **리플렉션으로 기본 생성자를 호출한다**. R8이 그 생성자를 지우면
# `NoSuchMethodException`이 나고 Analytics·FCM 초기화가 통째로 실패한다 —
# 2026-08-31 실기기 로그에서 실제로 났다:
#
#   Could not instantiate com.google.firebase.installations.FirebaseInstallationsKtxRegistrar
#   Caused by: java.lang.NoSuchMethodException: <init> []
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keepclassmembers class * {
    @com.google.firebase.components.Component *;
}
# Registrar는 이름으로 찾으므로 클래스 이름 자체가 남아야 한다.
-keepnames class com.google.firebase.components.ComponentRegistrar
-keep class * implements com.google.firebase.components.ComponentRegistrar { <init>(); }

# 리플렉션으로 이름을 읽는 코드가 흔하다(직렬화·DI). 제네릭·애노테이션 메타데이터를
# 지우면 그런 코드가 조용히 실패한다.
-keepattributes Signature,InnerClasses,EnclosingMethod,*Annotation*

# **2026-08-26부터 실제로 적용된다** — release에서 `isMinifyEnabled`와
# `isShrinkResources`를 켰다(사용자 결정). 위 카카오 규칙이 없으면 지도가 뜨지
# 않으므로 함께 확인해야 한다.
#
# 난독화된 크래시 로그를 되돌리려면 매핑 파일을 Play에 올린다:
#   build/app/outputs/mapping/prodRelease/mapping.txt
