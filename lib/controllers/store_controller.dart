import 'package:get/get.dart';
import '../models/store.dart';
import 'package:shared_preferences.dart';
import 'dart:convert';

class StoreController extends GetxController {
  final Rxn<Store> selectedStore = Rxn<Store>();

  @override
  void onInit() {
    super.onInit();
    loadSelectedStore();
  }

  // 保存选中的门店
  Future<void> setSelectedStore(Store store) async {
    selectedStore.value = store;
    // 保存到本地存储
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_store', jsonEncode(store.toJson()));
  }

  // 从本地存储加载选中的门店
  Future<void> loadSelectedStore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storeJson = prefs.getString('selected_store');
      if (storeJson != null) {
        final storeMap = jsonDecode(storeJson);
        selectedStore.value = Store.fromJson(storeMap);
      }
    } catch (e) {
      print('加载选中门店失败: $e');
    }
  }

  // 清除选中的门店
  Future<void> clearSelectedStore() async {
    selectedStore.value = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_store');
  }
}
