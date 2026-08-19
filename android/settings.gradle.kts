pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.0.1" apply false
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
    // FCM(SPEC-0028). **여기서는 버전만 선언하고 붙이지 않는다**(`apply false`) —
    // 실제 적용은 `app/build.gradle.kts`가 google-services.json이 있을 때만 한다.
    // 파일이 없는 머신에서도 빌드가 되어야 하기 때문이다(설계 §9 · R14).
    id("com.google.gms.google-services") version "4.4.2" apply false
}

include(":app")
