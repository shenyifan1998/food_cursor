import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';

class CityService {
  static const String _baseUrl = 'http://localhost:8080/api/cities';

  Future<CityGroupResponse> getCityGroups() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/groups'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['result'] == 'SUCCESS') {
          return CityGroupResponse.fromJson(data['data']);
        }
      }
      throw Exception(
          jsonDecode(utf8.decode(response.bodyBytes))['message'] ?? '获取城市列表失败');
    } catch (e) {
      throw Exception('网络错误: ${e.toString()}');
    }
  }
}

class CityGroupResponse {
  final List<City> hotCities;
  final List<City> allCities;

  CityGroupResponse({
    required this.hotCities,
    required this.allCities,
  });

  factory CityGroupResponse.fromJson(Map<String, dynamic> json) {
    return CityGroupResponse(
      hotCities: (json['hotCities'] as List)
          .map((item) => City.fromJson(item))
          .toList(),
      allCities: (json['allCities'] as List)
          .map((item) => City.fromJson(item))
          .toList(),
    );
  }
}
