/// NotificationItem Model - Mirrors React's NotificationItem type
/// Represents app notifications (conversion complete, storage warning, etc.)

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool unread;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.unread,
  });

  /// Create from JSON
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      time: json['time'],
      unread: json['unread'] ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'time': time,
      'unread': unread,
    };
  }

  /// Create a copy with updated fields
  NotificationItem copyWith({bool? unread}) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      time: time,
      unread: unread ?? this.unread,
    );
  }

  /// Initial sample data (matches React app)
  static List<NotificationItem> initialNotifications = [
    NotificationItem(
      id: 'n1',
      title: 'Conversion Complete',
      message: 'Marketing_Plan_2025.pdf is ready to listen.',
      time: '2m ago',
      unread: true,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Storage Warning',
      message: 'You have used 80% of your free storage.',
      time: '1h ago',
      unread: true,
    ),
    NotificationItem(
      id: 'n3',
      title: 'New Feature Available',
      message: 'Dark mode has arrived! Try it out in settings.',
      time: '2d ago',
      unread: false,
    ),
    NotificationItem(
      id: 'n4',
      title: 'Weekly Report',
      message: 'You spent 4.2 hours listening this week.',
      time: '1w ago',
      unread: false,
    ),
  ];
}
