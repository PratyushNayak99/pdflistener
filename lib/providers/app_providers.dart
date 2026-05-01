import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/file_item.dart';
import '../models/notification_item.dart';

import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

/// Files Provider - Manages list of converted documents
class FilesNotifier extends StateNotifier<List<FileItem>> {
  final ApiService apiService;

  FilesNotifier(this.apiService) : super([]) {
    // Initial fetch if we want, but usually better to let UI trigger it
  }

  Future<void> fetchFiles() async {
    try {
      final files = await apiService.getFiles();
      state = files;
    } catch (e) {
      print('Error fetching files: $e');
    }
  }

  Future<void> deleteFile(String id) async {
    try {
      await apiService.deleteFile(id);
      state = state.where((f) => f.id != id).toList();
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  void addFile(FileItem file) {
    state = [file, ...state];
  }
}

final filesProvider = StateNotifierProvider<FilesNotifier, List<FileItem>>((ref) {
  return FilesNotifier(ref.watch(apiServiceProvider));
});

/// Notifications Provider - Manages app notifications
class NotificationsNotifier extends StateNotifier<List<NotificationItem>> {
  final ApiService apiService;

  NotificationsNotifier(this.apiService) : super([]);

  Future<void> fetchNotifications() async {
    try {
      final notifications = await apiService.getNotifications();
      state = notifications;
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  Future<void> markAllRead() async {
    try {
      await apiService.markAllRead();
      state = state.map((n) => n.copyWith(unread: false)).toList();
    } catch (e) {
      print('Error marking all as read: $e');
    }
  }

  Future<void> markRead(String id) async {
    try {
      await apiService.markRead(id);
      state = state.map((n) => n.id == id ? n.copyWith(unread: false) : n).toList();
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  void addNotification(NotificationItem notification) {
    state = [notification, ...state];
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<NotificationItem>>((ref) {
  return NotificationsNotifier(ref.watch(apiServiceProvider));
});

/// Current Screen Provider - Manages navigation state
/// Replaces React's useState<ScreenType>

enum AppScreen {
  login,
  home,
  settings,
  upload,
  processing,
  player,
  library,
  help,
  notifications,
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

final userNameProvider = StateProvider<String>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return prefs.getString('userName') ?? 'Alex Carter';
});

final currentScreenProvider = StateProvider<AppScreen>((ref) => AppScreen.login);
