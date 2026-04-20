import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_providers.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/upload_screen.dart';
import '../screens/processing_screen.dart';
import '../screens/player_screen.dart';
import '../screens/library_screen.dart';
import '../screens/help_screen.dart';
import '../screens/notifications_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// Screen to path mapping
const _screenPaths = {
  AppScreen.login: '/login',
  AppScreen.home: '/home',
  AppScreen.settings: '/settings',
  AppScreen.upload: '/upload',
  AppScreen.processing: '/processing',
  AppScreen.player: '/player',
  AppScreen.library: '/library',
  AppScreen.help: '/help',
  AppScreen.notifications: '/notifications',
};

// Provider for the router - allows updating from Riverpod
final goRouterProvider = Provider<GoRouter>((ref) => appRouter);

// Provider that syncs currentScreenProvider to router
final routerSyncProvider = Provider<void>((ref) {
  ref.listen<AppScreen>(currentScreenProvider, (prev, next) {
    final path = _screenPaths[next];
    if (path != null && ref.read(goRouterProvider).location != path) {
      ref.read(goRouterProvider).go(path);
    }
  });
});

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(onLogin: () => context.go('/home')),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/upload',
      builder: (context, state) => const UploadScreen(),
    ),
    GoRoute(
      path: '/processing',
      builder: (context, state) => ProcessingScreen(onComplete: () => context.go('/player')),
    ),
    GoRoute(
      path: '/player',
      builder: (context, state) => const PlayerScreen(),
    ),
    GoRoute(
      path: '/library',
      builder: (context, state) => const LibraryScreen(),
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => const HelpScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
  ],
);

/// Extension to navigate via WidgetRef
extension RouterX on WidgetRef {
  void navigateTo(AppScreen screen) {
    final path = _screenPaths[screen];
    if (path != null) {
      context.go(path);
    }
  }
}
