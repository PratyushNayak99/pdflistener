import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/theme_provider.dart';
import 'router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

    return MaterialApp.router(
      title: 'PDF Listener',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,

      // Router Configuration
      routerConfig: appRouter,

      // Builder for global overlays
      builder: (context, child) {
        return child ?? const SizedBox();
      },
    );
  }
}
