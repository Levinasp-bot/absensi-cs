plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // ✅ Tambahkan ini
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.absensi_cs"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.absensi_cs"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Tambahkan Firebase BOM
    implementation(platform("com.google.firebase:firebase-bom:32.7.2"))

    // ✅ Firebase Authentication (bisa ditambah firestore/dll juga)
    implementation("com.google.firebase:firebase-auth")

    // ✅ Tambahkan dependency Kotlin jika dibutuhkan
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7")
}
