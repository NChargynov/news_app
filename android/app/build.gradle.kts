plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.geeks.newsapp.news_app"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.geeks.newsapp.news_app"
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

flutter {
    source = "../.."
}

dependencies {
    // Подключаем набор совместимых реализаций Java API для desugaring.
    //
    // Строка `isCoreLibraryDesugaringEnabled = true` только включает механизм,
    // а эта зависимость добавляет саму библиотеку `desugar_jdk_libs`, где лежат
    // реализации Java 8+ API для старых Android-версий.
    //
    // Проще: если плагин вызывает новый Java API, Android Gradle Plugin
    // подставляет совместимую реализацию из `desugar_jdk_libs`, чтобы код
    // работал не только на новых Android, но и на устройствах ниже нужного API.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
