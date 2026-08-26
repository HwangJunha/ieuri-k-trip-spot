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

        // **x86_64를 빼고 실기기 ABI만 싣는다**(사용자 결정 2026-08-26).
        // 네이티브 라이브러리가 ABI마다 통째로 들어가 셋이면 ~101MB다. x86_64는
        // 에뮬레이터 전용이라 스토어 배포본에 있을 이유가 없다.
        //
        // **에뮬레이터로 개발한다면 이 줄이 문제가 된다** — 디버그 빌드도 함께
        // 걸리므로 x86_64 에뮬레이터에서는 앱이 설치되지 않는다. Apple Silicon
        // 맥의 기본 에뮬레이터 이미지는 arm64라 대개 그대로 돌아간다.
        //
        // AAB로 올리면 Play가 기기별로 쪼개 주므로 이 필터가 없어도 사용자
        // 다운로드는 작다. 그래도 두는 이유는 APK를 직접 돌리는 경우
        // (`flutter run --release`, 사내 배포)까지 함께 줄이기 위해서다.
        //
        // **`clear()`가 먼저다.** Flutter 3.35+가 non-debuggable 빌드에 기본
        // `abiFilters`(armeabi-v7a·arm64-v8a·x86_64)를 스스로 넣기 때문에,
        // `+=`로는 그 위에 더해질 뿐이라 x86_64가 그대로 남는다 — 실제로 처음
        // 빌드했을 때 24MB가 남아 있었다. 공식 문서가 지정한 방법이다:
        // docs.flutter.dev/release/breaking-changes/default-abi-filters-android
        ndk {
            abiFilters.clear()
            abiFilters.addAll(listOf("arm64-v8a", "armeabi-v7a"))
        }
    }

    // 개발과 운영을 **한 기기에 함께 깔기 위해** applicationId를 가른다
    // (2026-08-25 결정). 같은 id면 한쪽이 다른 쪽을 덮어써, 운영에서 난 버그를
    // 개발 빌드로 재현하려면 지웠다 깔기를 반복해야 한다.
    //
    // AGP 8부터 기본으로 꺼져 있다 — 아래 `resValue`를 쓰려면 명시해야 한다.
    buildFeatures {
        resValues = true
    }

    // **두 flavor의 applicationId가 같다.** 예전에는 dev에 `.dev` 접미사를 붙여
    // 한 기기에 두 앱을 함께 깔았는데, 그것을 걷어냈다(사용자 결정 2026-08-25).
    //
    // 이유는 **테스트 트랙에 올라가는 앱이 운영 번들이어야 하기 때문**이다. 스토어는
    // 번들 하나를 앱 하나로 보므로, 비공개 테스트(12명·14일)로 프로덕션 자격을 쌓으려면
    // 그 빌드의 번들이 출시할 번들과 같아야 한다. 서버는 `--dart-define-from-file`이
    // 가르므로 번들까지 가를 이유가 없다 — 로컬 개발도 개발 서버를 본다.
    //
    // ```
    // 테스트: --flavor prod --dart-define-from-file=.env.dev   (개발 서버)
    // 출시  : --flavor prod --dart-define-from-file=.env.prod  (운영 서버)
    // ```
    //
    // flavor는 앱 이름을 가르는 용도로만 남는다. 접미사를 되살리면 그 빌드는 스토어의
    // 다른 앱이 되어 14일 카운트가 끊긴다.
    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            // 홈 화면에서 구분되도록 이름만 다르다. **번들은 운영과 같다**(위 주석).
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
            // **R8과 리소스 축소를 켠다**(사용자 결정 2026-08-26). 지금까지 꺼져
            // 있어 dex가 그대로 실리고 안 쓰는 리소스도 남았다.
            //
            // 난독화가 크래시 로그를 바꾸므로 매핑 파일을 Play에 올려야 스택
            // 트레이스를 되돌릴 수 있다 —
            // `build/app/outputs/mapping/prodRelease/mapping.txt`.
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )

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
