import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/store.dart';

class StoreService {
  static const String _baseUrl = 'http://localhost:8080/api/stores';

  // 获取附近门店
  Future<List<Store>> getNearbyStores(
      double longitude, double latitude, String cityCode) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/nearby?longitude=$longitude&latitude=$latitude&cityCode=$cityCode'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['result'] == 'SUCCESS') {
          return (data['data'] as List)
              .map((item) => Store.fromJson(item))
              .toList();
        }
      }
      throw Exception(
          jsonDecode(utf8.decode(response.bodyBytes))['message'] ?? '获取门店列表失败');
    } catch (e) {
      throw Exception('网络错误: ${e.toString()}');
    }
  }

  // 获取城市门店
  Future<List<Store>> getStoresByCity(String cityCode) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/city/$cityCode'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['result'] == 'SUCCESS') {
          return (data['data'] as List)
              .map((item) => Store.fromJson(item))
              .toList();
        }
      }
      throw Exception(
          jsonDecode(utf8.decode(response.bodyBytes))['message'] ?? '获取门店列表失败');
    } catch (e) {
      throw Exception('网络错误: ${e.toString()}');
    }
  }
}
