# Build Guide - PDF Listener Flutter APK

This guide walks you through building the production-ready Android APK from the React web prototype.

## Prerequisites Checklist

- [ ] Flutter SDK 3.5.0+ installed (`flutter --version`)
- [ ] Java JDK 17+ installed (`java --version`)
- [ ] Android Studio with Android SDK
- [ ] Android device or emulator for testing

## Quick Start

### 1. Verify Flutter Installation

```bash
flutter doctor
```

Ensure all checks pass. If not, follow the instructions to fix any issues.

### 2. Navigate to Project

```bash
cd pdf_listener_app
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Add App Icons (Optional but Recommended)

Create your app icon images:
- `assets/icons/app_icon.png` - 1024x1024px icon with headphones on orange/black background
- `assets/icons/app_icon_foreground.png` - 432x432px foreground layer for adaptive icons

Then run:

```bash
flutter pub run flutter_launcher_icons
```

### 5. Generate Splash Screen

```bash
flutter pub run flutter_native_splash:create
```

### 6. Run in Debug Mode

Connect your Android device or start an emulator, then:

```bash
flutter run
```

### 7. Build Release APK

```bash
flutter build apk --release --target-platform android-arm,android-arm64,android-x64
```

The APK will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Build Optimizations

### Split APKs by ABI (Smaller Downloads)

```bash
flutter build apk --release --split-per-abi
```

This creates three smaller APKs:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM - most modern phones)
- `app-x86_64-release.apk` (x86_64 - emulators)

### Build Android App Bundle (For Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## Troubleshooting

### "No devices found"

```bash
flutter devices
```

If no devices appear:
- Enable USB debugging on your Android device
- Connect via USB
- Or create an emulator in Android Studio

### "Gradle build failed"

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

### "License not accepted"

```bash
flutter doctor --android-licenses
```

Accept all licenses by pressing `y` for each prompt.

### "Missing fonts"

If you see font errors, either:
1. Add the Inter font files to `assets/fonts/`
2. Or remove the font configuration from `pubspec.yaml` and use system fonts

## Testing the Build

### 1. Install APK on Device

```bash
flutter install
```

Or manually copy `app-release.apk` to your device and install.

### 2. Test Key Features

- [ ] Login screen animations
- [ ] Dark mode toggle (persists after app restart)
- [ ] File upload (file picker opens)
- [ ] Processing screen pulse animation
- [ ] Player screen controls
- [ ] Library swipe-to-delete
- [ ] Notifications screen

## Release Checklist

Before distributing the APK:

- [ ] Update `version` in `pubspec.yaml` (e.g., `2.0.4+492`)
- [ ] Update `versionCode` and `versionName` in `android/app/build.gradle`
- [ ] Add real app icons
- [ ] Test on multiple devices/emulators
- [ ] Remove any debug code
- [ ] Enable ProGuard/R8 (already configured in `build.gradle`)
- [ ] Sign the APK (for distribution outside Play Store)

## Signing the APK (For Distribution)

### Generate a Keystore

```bash
keytool -genkey -v -keystore ~/pdf-listener-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pdf_listener
```

### Configure Signing

Create `android/key.properties`:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=pdf_listener
storeFile=/home/your-user/pdf-listener-key.jks
```

### Update build.gradle

Add to `android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            ...
        }
    }
}
```

## Performance Benchmarks

Expected performance on mid-range devices (Snapdragon 665+):

| Metric | Target |
|--------|--------|
| App Size (APK) | ~15-20 MB |
| Cold Start | < 2 seconds |
| Screen Transitions | 60 FPS |
| Animation Smoothness | 60 FPS |
| Memory Usage | < 100 MB |

## Next Steps

After building:

1. **Deploy to Testing**: Share APK with testers via Google Drive, Dropbox, etc.
2. **Play Store Internal Testing**: Upload AAB to Play Console
3. **Gather Feedback**: Use feedback to iterate on design/functionality
4. **CI/CD Setup**: Automate builds with GitHub Actions, Codemagic, etc.

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Android Developers Guide](https://developer.android.com/guide)
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/rendering/performance)
