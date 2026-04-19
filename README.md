# PDF Listener App (Flutter)

A production-ready Flutter Android APK that converts the React web prototype into a native mobile application.

## Features

- **1:1 Design Translation**: Pixel-perfect match of the React/Tailwind design
- **Dark Mode**: Persisted theme toggle with smooth transitions
- **Framer Motion Animations**: Recreated using flutter_animate
- **Lucide Icons**: Direct replacement for Lucide React icons
- **File Upload**: PDF/DOC/DOCX picker integration
- **Audio Playback**: just_audio integration for real playback
- **Smooth Transitions**: Custom page transitions matching web animations

## Architecture

```
lib/
├── main.dart                 # App entry point
├── router/
│   └── app_router.dart       # go_router configuration
├── providers/
│   ├── theme_provider.dart   # Dark mode state management
│   └── app_providers.dart    # Files, notifications, navigation
├── models/
│   ├── file_item.dart        # File data model
│   └── notification_item.dart # Notification data model
├── screens/
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── settings_screen.dart
│   ├── upload_screen.dart
│   ├── processing_screen.dart
│   ├── player_screen.dart
│   ├── library_screen.dart
│   ├── help_screen.dart
│   └── notifications_screen.dart
└── widgets/
    ├── animated_scale_button.dart  # Tap animation wrapper
    ├── action_card.dart            # Dashboard action cards
    ├── search_bar_widget.dart      # Search with voice button
    └── custom_app_bar.dart         # Custom header component
```

## Dependencies

| Package | Purpose |
|---------|---------|
| go_router | Navigation & deep linking |
| flutter_riverpod | State management |
| flutter_animate | Framer Motion equivalent |
| lucide_icons | Icon library |
| file_picker | PDF upload |
| just_audio | Audio playback |
| shared_preferences | Persist settings |
| dotted_border | Upload zone styling |
| google_fonts | Inter font |

## Setup

### Prerequisites

- Flutter SDK 3.5.0 or higher
- Java JDK 17 or higher (for Android builds)
- Android Studio with Android SDK

### Installation

```bash
cd pdf_listener_app

# Install dependencies
flutter pub get

# Generate app icons (requires assets/icons/app_icon.png)
flutter pub run flutter_launcher_icons

# Generate splash screen
flutter pub run flutter_native_splash:create

# Run on connected device/emulator
flutter run

# Build release APK
flutter build apk --release --target-platform android-arm,android-arm64,android-x64
```

The APK will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Key Differences from React Version

| React/Web | Flutter/Native |
|-----------|----------------|
| `motion.div` | `flutter_animate` extensions |
| `active:scale-95` | `AnimatedScaleButton` widget |
| Tailwind classes | `BoxDecoration` styles |
| React Context | Riverpod providers |
| React Router | go_router |
| CSS borderRadius | `BorderRadius.circular()` |
| SVG components | `CustomPainter` |

## Color Palette

```dart
// Light Mode
scaffoldBackground: 0xFFF2F2F7
cardBackground: 0xFFFFFFFF
primaryBlue: 0xFF5B8DEF
textPrimary: 0xFF1C1C1E
textSecondary: 0xFF9CA3AF

// Dark Mode
scaffoldBackground: 0xFF000000
cardBackground: 0xFF1C1C1E
textPrimary: 0xFFFFFFFF
```

## Animations

All animations use `flutter_animate` for declarative syntax:

```dart
// Fade in + slide up (matches Framer Motion)
Widget()
  .animate()
  .fadeIn(duration: 400.ms, delay: 100.ms)
  .slideY(begin: 0.1, end: 0, duration: 400.ms)

// Pulse animation (concentric circles)
Container()
  .animate(onPlay: (controller) => controller.repeat())
  .scale(duration: 2.seconds, begin: Offset(1,1), end: Offset(1.8, 1.8))
  .fadeOut(duration: 2.seconds)
```

## Building for Production

### 1. Add App Icons

Place your icon files in `assets/icons/`:
- `app_icon.png` (1024x1024) - Main icon
- `app_icon_foreground.png` (432x432) - Android adaptive icon foreground

### 2. Update App Name

Edit `android/app/src/main/res/values/strings.xml`:
```xml
<string name="app_name">PDF Listener</string>
```

### 3. Configure Permissions

The `AndroidManifest.xml` already includes:
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

### 4. Build

```bash
flutter build apk --release --split-per-abi
```

This creates separate APKs for each ABI (smaller file sizes).

## License

MIT
