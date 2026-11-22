plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.medelyes970.gate"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.medelyes970.gate"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")

            // ── Size Optimizations ──────────────────────────────────────
            // R8 dead-code elimination (replaces ProGuard)
            isMinifyEnabled = true
            // Remove unused Android resources (strings, drawables, layouts)
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    // ── ABI Splits (release only) ───────────────────────────────────────
    // Produces one slim APK per CPU architecture instead of one fat APK.
    // Only enabled for release — Flutter injects its own abiFilters for debug builds
    // which would conflict with a global splits.abi block.
    splits {
        abi {
            val isReleaseBuild = gradle.startParameter.taskNames.any {
                it.contains("Release", ignoreCase = true)
            }
            isEnable = isReleaseBuild
            if (isReleaseBuild) {
                reset()
                include("arm64-v8a", "armeabi-v7a", "x86_64")
                isUniversalApk = false
            }
        }
    }
}

flutter {
    source = "../.."
}
