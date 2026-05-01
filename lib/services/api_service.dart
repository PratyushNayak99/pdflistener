import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/file_item.dart';
import '../models/notification_item.dart';

class ApiService {
  // Use the live Render backend URL
  static const String baseUrl = 'https://pdflistener-backend.onrender.com';
  String? _token;

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  void setToken(String token) {
    _token = token;
  }
  
  String? get token => _token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Auth
  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['access_token'];
      return _token!;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/users/me'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user profile: ${response.body}');
    }
  }

  // Files
  Future<FileItem> uploadFile(String filePath) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/v1/files/upload'));
    if (_token != null) {
      request.headers['Authorization'] = 'Bearer $_token';
    }
    request.files.add(await http.MultipartFile.fromPath('file', filePath));
    
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return FileItem.fromJson(data);
    } else {
      throw Exception('Failed to upload file: ${response.body}');
    }
  }

  Future<FileItem> getFileStatus(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/files/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return FileItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get file status: ${response.body}');
    }
  }

  Future<List<FileItem>> getFiles() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/files/'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List items = data['items'] ?? [];
      return items.map((json) => FileItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get files: ${response.body}');
    }
  }
  
  Future<void> deleteFile(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/v1/files/$id'),
      headers: _headers,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete file: ${response.body}');
    }
  }

  // Notifications
  Future<List<NotificationItem>> getNotifications() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/notifications/'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List items = data['items'] ?? [];
      return items.map((json) => NotificationItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get notifications: ${response.body}');
    }
  }

  Future<void> markAllRead() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/notifications/mark-all-read'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark all read: ${response.body}');
    }
  }

  Future<void> markRead(String id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/api/v1/notifications/$id/read'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark read: ${response.body}');
    }
  }
}
