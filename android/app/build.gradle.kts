import java.util.Properties

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

// 릴리스 서명 키(출시 필수). `key.properties`는 키스토어 비밀번호를 담으므로
// **커밋하지 않는다**(.gitignore). 파일이 없으면 아래 buildTypes가 디버그 키로
// 물러나 `flutter run --release`는 계속 되지만, **그 산출물은 스토어에 올릴 수
// 없다** — Play는 디버그 서명 AAB를 거부한다.
//
// 만드는 법은 `android/key.properties.example` 참고.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        keystorePropertiesFile.inputStream().use { load(it) }
    }
}
val hasReleaseKeystore = keystorePropertiesFile.exists() &&
    keystoreProperties.getProperty("storeFile") != null

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

    // 개발과 운영을 **한 기기에 함께 깔기 위해** applicationId를 가른다
    // (2026-08-25 결정). 같은 id면 한쪽이 다른 쪽을 덮어써, 운영에서 난 버그를
    // 개발 빌드로 재현하려면 지웠다 깔기를 반복해야 한다.
    //
    // **운영은 접미사를 붙이지 않는다.** applicationId는 스토어에서 앱의 정체성이라
    // 한 번 올리면 바꿀 수 없다 — 새로 받는 쪽은 개발이다.
    // AGP 8부터 기본으로 꺼져 있다 — 아래 `resValue`를 쓰려면 명시해야 한다.
    buildFeatures {
        resValues = true
    }

    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            // 홈 화면에서 바로 구분되어야 한다. 아이콘까지 다르게 하는 것은
            // 별도 작업이고, 우선 이름으로 가른다.
            resValue("string", "app_name", "KTS Dev")
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "K-Trip Spot")
        }
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // 키가 있으면 릴리스 키로, 없으면 디버그 키로 서명한다.
            //
            // **디버그 키로 서명된 산출물은 스토어에 올릴 수 없다** — Play가 거부한다.
            // 그래도 빌드를 막지 않는 이유는 `flutter run --release`로 성능을 재는
            // 흔한 작업까지 키스토어를 요구하게 되기 때문이다(google-services.json을
            // 다루는 방식과 같은 판단). 대신 올릴 수 없다는 사실을 빌드 로그에 남긴다.
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                logger.lifecycle(
                    "[release] android/key.properties가 없어 디버그 키로 서명한다 — " +
                        "이 산출물은 Play에 업로드할 수 없다. key.properties.example 참고."
                )
                signingConfigs.getByName("debug")
            }
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
