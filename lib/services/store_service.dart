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

  Future<List<Store>> getFavoriteStores() async {
    try {
      // TODO: 从服务器获取收藏的门店
      // 临时返回模拟数据
      await Future.delayed(const Duration(milliseconds: 500)); // 模拟网络延迟
      return [
        Store(
          id: 1,
          name: '唐山爱琴海店',
          address: '河北省唐山市路北区爱琴海购物公园6层F6016',
          businessHours: '09:30-21:30',
          distance: 0.5,
          isOpen: true,
          supportsTakeout: true,
          cityName: '唐山市',
          phone: '0315-12345678',
          isFavorite: true,
        ),
        Store(
          id: 2,
          name: '唐山吾悦广场店',
          address: '河北省唐山市路北区吾悦广场3层306',
          businessHours: '09:25-23:59',
          distance: 1.2,
          isOpen: true,
          supportsTakeout: true,
          cityName: '唐山市',
          phone: '0315-87654321',
          isFavorite: true,
        ),
      ];
    } catch (e) {
      throw Exception('获取收藏门店失败：$e');
    }
  }
}
