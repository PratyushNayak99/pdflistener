/// FileItem Model - Mirrors React's FileItem type
/// Represents a converted PDF document with audio

class FileItem {
  final String id;
  final String title;
  final String size;
  final String duration;
  final String date;
  final String status;
  final String? audioUrl;

  FileItem({
    required this.id,
    required this.title,
    required this.size,
    required this.duration,
    required this.date,
    this.status = 'completed',
    this.audioUrl,
  });

  /// Create from JSON
  factory FileItem.fromJson(Map<String, dynamic> json) {
    return FileItem(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      size: json['size'] ?? '',
      duration: json['duration'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'completed',
      audioUrl: json['audio_url'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'size': size,
      'duration': duration,
      'date': date,
      'status': status,
      'audio_url': audioUrl,
    };
  }

  /// Initial sample data (matches React app)
  static List<FileItem> initialFiles = [
    FileItem(
      id: '1',
      title: 'Design_Document_v2.pdf',
      size: '4.2 MB',
      duration: '12m',
      date: 'Today',
    ),
    FileItem(
      id: '2',
      title: 'Product_Strategy_Q3.pdf',
      size: '2.1 MB',
      duration: '8m',
      date: 'Yesterday',
    ),
    FileItem(
      id: '3',
      title: 'Marketing_Plan_2025.pdf',
      size: '3.4 MB',
      duration: '17m',
      date: '4 days ago',
    ),
    FileItem(
      id: '4',
      title: 'Employee_Handbook.pdf',
      size: '12.4 MB',
      duration: '45m',
      date: 'Sep 28',
    ),
  ];
}
