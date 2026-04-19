# React to Flutter Migration Guide

This document maps every React/Tailwind concept from the web prototype to its Flutter equivalent.

## Component Mapping

### React Components → Flutter Widgets

| React Component | Flutter Equivalent | File Location |
|-----------------|-------------------|---------------|
| `motion.div` | `flutter_animate` extensions | All screens |
| `AnimatePresence` | `CustomTransitionPage` | `router/app_router.dart` |
| `useState` | `StateNotifier` / `StatefulWidget` | `providers/` |
| `useEffect` | `initState` / `didUpdateWidget` | Screen widgets |
| `useCallback` | Class methods | Widget classes |
| `useRef` | `GlobalKey` / controller | Various |
| `Fragment` | `Column` / `Row` / `Stack` | Layout widgets |

### Icon Mapping (Lucide React → Lucide Icons Flutter)

```dart
// React
import { ArrowRight, HelpCircle, Bell } from 'lucide-react';
<ArrowRight size={24} />

// Flutter
import 'package:lucide_icons/lucide_icons.dart';
Icon(LucideIcons.arrowRight, size: 24)
```

All icons from the React app are available in `lucide_icons` package.

## Styling Translation

### Tailwind → BoxDecoration

| Tailwind Class | Flutter Equivalent |
|---------------|-------------------|
| `bg-[#F2F2F7]` | `color: Color(0xFFF2F2F7)` |
| `rounded-[32px]` | `BorderRadius.circular(32)` |
| `shadow-sm` | `BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)` |
| `border-[1px]` | `Border.all(color: Color, width: 1)` |
| `flex items-center` | `Row(mainAxisAlignment: MainAxisAlignment.center)` |
| `flex justify-between` | `Row(mainAxisAlignment: MainAxisAlignment.spaceBetween)` |
| `grid grid-cols-2` | `GridView.count(crossAxisCount: 2)` |
| `w-[390px]` | `width: 390` |
| `h-[844px]` | `height: 844` |
| `p-6` | `padding: EdgeInsets.all(24)` |
| `m-4` | `margin: EdgeInsets.all(16)` |
| `gap-4` | `SizedBox(height: 16)` between children |

### Example: Card Component

```tsx
// React/Tailwind
<div className="bg-white rounded-[32px] p-6 shadow-sm border border-gray-100">
  <h3 className="font-bold text-[18px]">Title</h3>
</div>
```

```dart
// Flutter
Container(
  padding: const EdgeInsets.all(24),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(32),
    border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
    ],
  ),
  child: const Text(
    'Title',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
)
```

## Animation Translation

### Framer Motion → Flutter Animate

| Framer Motion | Flutter Animate |
|--------------|-----------------|
| `initial={{ opacity: 0 }}` | `.fadeIn(duration: 400.ms)` |
| `animate={{ opacity: 1 }}` | Built into `.animate()` |
| `exit={{ opacity: 0 }}` | Reverse transition in `CustomTransitionPage` |
| `transition={{ delay: 0.1 }}` | `.delay(100.ms)` or `delay: 100.ms` |
| `scale: 0.95` (on tap) | `AnimatedScaleButton` widget |
| `y: "100%"` (slide up) | `SlideTransition` with `Offset(0, 1)` |

### Example: Fade In + Slide

```tsx
// React
<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ delay: 0.1, duration: 0.4 }}
>
  Content
</motion.div>
```

```dart
// Flutter
Content()
  .animate()
  .fadeIn(duration: 400.ms, delay: 100.ms)
  .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 100.ms)
```

### Example: Pulse Animation

```tsx
// React
{[...Array(3)].map((_, i) => (
  <motion.div
    animate={{ scale: [1, 1.8, 1], opacity: [1, 0, 1] }}
    transition={{ repeat: Infinity, duration: 2, delay: i * 0.6 }}
  />
))}
```

```dart
// Flutter
Container()
  .animate(onPlay: (controller) => controller.repeat())
  .scale(duration: 2.seconds, begin: Offset(1,1), end: Offset(1.8, 1.8))
  .fadeOut(duration: 2.seconds)
```

## State Management

### React Context → Riverpod

```tsx
// React
const [isDarkMode, setIsDarkMode] = useState(false);
const [files, setFiles] = useState<FileItem[]>(INITIAL_FILES);
```

```dart
// Flutter with Riverpod
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());
final filesProvider = StateNotifierProvider<FilesNotifier, List<FileItem>>((ref) => FilesNotifier());

// Usage
final isDark = ref.watch(themeProvider);
ref.read(themeProvider.notifier).toggleTheme();
```

## Navigation

### React Router → GoRouter

```tsx
// React
import { useNavigate } from 'react-router-dom';
const navigate = useNavigate();
navigate('/player');
```

```dart
// Flutter
context.go('/player');
// or with Riverpod
ref.read(currentScreenProvider.notifier).state = AppScreen.player;
```

## File Handling

### Web File Input → File Picker

```tsx
// React
<input type="file" ref={fileInputRef} accept=".pdf" onChange={handleFileChange} />
```

```dart
// Flutter
FilePickerResult? result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['pdf'],
);
```

## Typography

### Font Configuration

| React (Tailwind) | Flutter |
|-----------------|---------|
| `font-sans` | `fontFamily: 'Inter'` |
| `text-[40px]` | `fontSize: 40` |
| `font-bold` | `fontWeight: FontWeight.bold` |
| `tracking-tight` | `letterSpacing: -0.5` |
| `leading-[1]` | `height: 1.0` |

## Color Palette Reference

| Variable | Light | Dark |
|----------|-------|------|
| Background | `0xFFF2F2F7` | `0xFF000000` |
| Card | `0xFFFFFFFF` | `0xFF1C1C1E` |
| Primary Blue | `0xFF5B8DEF` | `0xFF5B8DEF` |
| Text Primary | `0xFF1C1C1E` | `0xFFFFFFFF` |
| Text Secondary | `0xFF9CA3AF` | `0xFF9CA3AF` |
| Orange Accent | `0xFFFF6B00` | `0xFFFF6B00` |
| Red Danger | `0xFFFF3B30` | `0xFFFF3B30` |

## Layout Patterns

### Phone Mockup Removal

The React app wraps everything in a phone mockup (`w-[390px] h-[844px]`). In Flutter, we use fullscreen:

```dart
// Instead of fixed-size container:
Scaffold(
  body: SafeArea(
    child: CustomScrollView(...),
  ),
)
```

### Floating Navigation

```tsx
// React
<div className="absolute bottom-[36px] left-[24px] right-[24px]">
```

```dart
// Flutter
Stack(
  children: [
    // Content
    Positioned(
      bottom: 36,
      left: 24,
      right: 24,
      child: // Navigation widget
    ),
  ],
)
```

## Key Differences

| Aspect | React/Web | Flutter |
|--------|-----------|---------|
| Rendering | DOM | Skia (GPU) |
| Styling | CSS/Tailwind | Widget properties |
| Animations | Framer Motion | flutter_animate |
| State | React hooks | Riverpod |
| Navigation | React Router | GoRouter |
| Icons | lucide-react | lucide_icons |
| File Upload | `<input type="file">` | file_picker package |
| Audio | HTML5 Audio | just_audio package |
| Persistence | localStorage | shared_preferences |

## Testing Checklist

After migration, verify:

- [ ] All screens render correctly
- [ ] Animations match timing/easing
- [ ] Dark mode persists after restart
- [ ] File picker opens for supported formats
- [ ] Back navigation works on Android
- [ ] Status bar doesn't overlap content
- [ ] Text doesn't overflow on small screens
- [ ] Touch targets are at least 48x48dp
