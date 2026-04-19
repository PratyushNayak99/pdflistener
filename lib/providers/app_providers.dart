import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/file_item.dart';
import '../models/notification_item.dart';

/// Files Provider - Manages list of converted documents
/// Replaces React's useState<FileItem[]>(INITIAL_FILES)

class FilesNotifier extends StateNotifier<List<FileItem>> {
  FilesNotifier() : super(FileItem.initialFiles);

  void deleteFile(String id) {
    state = state.where((f) => f.id != id).toList();
  }

  void addFile(FileItem file) {
    state = [file, ...state];
  }
}

final filesProvider = StateNotifierProvider<FilesNotifier, List<FileItem>>((ref) {
  return FilesNotifier();
});

/// Notifications Provider - Manages app notifications
/// Replaces React's useState<NotificationItem[]>(INITIAL_NOTIFICATIONS)

class NotificationsNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationsNotifier() : super(NotificationItem.initialNotifications);

  void markAllRead() {
    state = state.map((n) => n.copyWith(unread: false)).toList();
  }

  void markRead(String id) {
    state = state.map((n) => n.id == id ? n.copyWith(unread: false) : n).toList();
  }

  void addNotification(NotificationItem notification) {
    state = [notification, ...state];
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<NotificationItem>>((ref) {
  return NotificationsNotifier();
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

final currentScreenProvider = StateProvider<AppScreen>((ref) => AppScreen.login);
