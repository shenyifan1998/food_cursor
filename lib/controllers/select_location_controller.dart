import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/store.dart';
import '../models/city.dart';
import '../services/store_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/city_select_page.dart';

class SelectLocationController extends GetxController {
  final StoreService _storeService = StoreService();
  final TextEditingController searchController = TextEditingController();
  final RxString selectedCity = '唐山市'.obs;
  final RxString selectedCityCode = '130200'.obs;
  final RxBool showFavorites = false.obs;
  final RxList<Store> stores = <Store>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStores();
  }

  Future<void> loadStores() async {
    try {
      isLoading.value = true;
      // 这里使用固定的经纬度作为测试，实际应该使用设备的GPS位置
      final storeList = await _storeService.getNearbyStores(
        118.1803500, // 测试用经度
        39.6331100, // 测试用纬度
        selectedCityCode.value,
      );
      stores.value = storeList;
    } catch (e) {
      Get.snackbar('错误', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectCity() async {
    final result = await Get.to(() => CitySelectPage());
    if (result != null && result is City) {
      selectedCity.value = result.name;
      selectedCityCode.value = result.code;
      loadStores(); // 重新加载该城市的门店
    }
  }

  void onSearchChanged(String value) {
    // TODO: 实现搜索功能
    if (value.isEmpty) {
      loadStores();
    } else {
      stores.value = stores
          .where((store) =>
              store.name.toLowerCase().contains(value.toLowerCase()) ||
              store.address.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
  }

  void toggleFavorite() {
    showFavorites.value = !showFavorites.value;
    loadStores(); // 重新加载门店列表
  }

  void selectStore(Store store) {
    Get.back(result: store);
  }

  Future<void> callStore(Store store) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: store.phone,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      Get.snackbar('错误', '无法拨打电话：${store.phone}');
    }
  }

  Future<void> navigateToStore(Store store) async {
    // TODO: 实现导航功能
    Get.snackbar('提示', '导航功能开发中');
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
