import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'http://localhost:8080/api/auth';

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200 && data['result'] == 'SUCCESS',
        'message': data['message'] ?? '未知错误',
      };
    } catch (e) {
      return {
        'success': false,
        'message': '网络错误: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200 && data['result'] == 'SUCCESS',
        'message': data['message'] ?? '未知错误',
        'token': data['data']?['token'],
      };
    } catch (e) {
      return {
        'success': false,
        'message': '网络错误: ${e.toString()}',
      };
    }
  }
}
