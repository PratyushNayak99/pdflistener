import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/theme_provider.dart';
import 'providers/app_providers.dart';
import 'router/app_router.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const PdfListenerApp(),
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
