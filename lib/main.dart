import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/theme_provider.dart';
import 'providers/app_providers.dart';
import 'router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable all debug overlays
  debugShowSizeOverlay = false;
  debugShowPaintedImages = false;
  debugRepaintRainbow = false;
  debugShowMaterialGrid = false;
  debugCheckElevations = false;

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: PdfListenerApp(),
    ),
  );
}

class PdfListenerApp extends ConsumerWidget {
  const PdfListenerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    // Initialize router sync listener
    ref.watch(routerSyncProvider);

    return MaterialApp.router(
      title: 'PDF Listener',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,

      // Router Configuration
      routerConfig: ref.watch(goRouterProvider),

      // Builder for global overlays
      builder: (context, child) {
        return child ?? const SizedBox();
      },
    );
  }
}
