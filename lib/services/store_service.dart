import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/store.dart';
import '../controllers/auth_controller.dart';

class StoreService {
  static const String _baseUrl = 'http://localhost:8080/api/stores';

  Map<String, String> get _headers {
    final token = Get.find<AuthController>().token.value;
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // 获取附近门店
  Future<List<Store>> getNearbyStores(
      double longitude, double latitude, String cityCode) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/nearby?longitude=$longitude&latitude=$latitude&cityCode=$cityCode'),
        headers: _headers,
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
        headers: _headers,
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
      print(e);
      throw Exception('网络错误: ${e.toString()}');
    }
  }

  // 获取收藏的门店列表
  Future<List<Store>> getFavoriteStores() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/favorites'),
        headers: _headers,
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
          jsonDecode(utf8.decode(response.bodyBytes))['message'] ?? '获取收藏门店失败');
    } catch (e) {
      print(e);
      throw Exception('网络错误: ${e.toString()}');
    }
  }

  // 添加收藏
  Future<void> addFavorite(int storeId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$storeId/favorite'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['result'] != 'SUCCESS') {
          throw Exception(data['message'] ?? '收藏失败');
        }
      } else {
        throw Exception('收藏失败');
      }
    } catch (e) {
      throw Exception('网络错误: ${e.toString()}');
    }
  }

  // 取消收藏
  Future<void> removeFavorite(int storeId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$storeId/favorite'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['result'] != 'SUCCESS') {
          throw Exception(data['message'] ?? '取消收藏失败');
        }
      } else {
        throw Exception('取消收藏失败');
      }
    } catch (e) {
      throw Exception('网络错误: ${e.toString()}');
    }
  }
}
