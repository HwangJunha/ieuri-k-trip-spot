plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// FCM 푸시(SPEC-0028). `google-services.json`은 환경마다 값이 달라 커밋하지 않는다
// (.gitignore — SNS 설정·`.env`와 같은 취급).
//
// **파일이 없으면 플러그인을 붙이지 않는다.** 무조건 붙이면 파일이 없는 머신에서
// Android 빌드가 통째로 실패하는데, 이 기능의 설계 원칙은 "알림을 못 받는 것이 앱을
// 막을 이유가 되지 않는다"이다(설계 §9 · R14). 빌드 차단은 그보다 훨씬 강한 차단이라
// 원칙과 어긋난다 — 지도 SDK를 키 없이도 기동되게 해 둔 판단과 같은 결이다.
//
// 파일이 없으면 `Firebase.initializeApp()`이 던지고, `PushInitializer`가 그것을 삼켜
// 앱은 알림 없이 정상 동작한다.
//
// CI에서는 빌드 전에 시크릿에서 이 파일을 복원해 두면 그대로 붙는다:
//   echo "$GOOGLE_SERVICES_JSON" | base64 -d > android/app/google-services.json
val googleServicesFile = file("google-services.json")
if (googleServicesFile.exists()) {
    apply(plugin = "com.google.gms.google-services")
} else {
    logger.lifecycle(
        "[SPEC-0028] android/app/google-services.json이 없어 FCM을 건너뛴다 — " +
            "빌드는 계속되고 앱은 알림 없이 동작한다."
    )
}

android {
    namespace = "kr.ieuri.ktripspot"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // `flutter_local_notifications`(SPEC-0028 알림 채널)가 요구한다 — 구버전
        // Android에서 java.time 등을 쓰기 위한 디슈가링이며, 없으면 빌드가
        // `checkDebugAarMetadata`에서 실패한다.
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "kr.ieuri.ktripspot"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 위 `isCoreLibraryDesugaringEnabled`가 요구하는 런타임 라이브러리.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
