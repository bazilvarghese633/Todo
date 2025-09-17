plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Required for Firebase
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.2.0"))

    // Firebase Analytics
    implementation("com.google.firebase:firebase-analytics")

    // Add Firestore (since you’re using it for To-Do app)
    implementation("com.google.firebase:firebase-firestore")

    // Add any other Firebase products here if needed
    // https://firebase.google.com/docs/android/setup#available-libraries
}

android {
    namespace = "com.example.todo_b1"
    compileSdk = 35  // Explicit number is better for stability
    ndkVersion = "27.0.12077973" // Match Firebase plugins requirement

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.todo_b1"
        minSdk = 23   // Required by cloud_firestore
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true // Helps avoid 64K method limit
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
