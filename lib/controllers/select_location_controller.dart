import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/store.dart';
import '../models/city.dart';
import '../services/store_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/city_select_page.dart';
import 'package:lpinyin/lpinyin.dart';

class SelectLocationController extends GetxController {
  final StoreService _storeService = StoreService();
  final TextEditingController searchController = TextEditingController();
  final RxString selectedCity = '唐山市'.obs;
  final RxString selectedCityCode = '130200'.obs;
  final RxBool showFavorites = false.obs;
  final RxList<Store> stores = <Store>[].obs;
  final RxList<Store> searchResults = <Store>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 延迟加载以避免初始化问题
    Future.delayed(Duration.zero, () {
      loadStores();
      searchController.addListener(_onSearchChanged);
    });
  }

  void _onSearchChanged() {
    try {
      final keyword = searchController.text.trim();
      if (keyword.isEmpty) {
        isSearching.value = false;
        searchResults.clear();
        return;
      }

      if (keyword.length >= 1) {
        isSearching.value = true;
        searchResults.value = _searchStores(keyword);
      }
    } catch (e) {
      print('Search error: $e');
      isSearching.value = false;
      searchResults.clear();
    }
  }

  List<Store> _searchStores(String keyword) {
    if (stores.isEmpty) return [];

    final String lowercaseKeyword = keyword.toLowerCase();
    return stores.where((store) {
      if (store.name.isEmpty) return false;

      // 匹配店铺名称
      if (store.name.toLowerCase().contains(lowercaseKeyword)) {
        return true;
      }
      // 匹配店铺地址
      if (store.address.toLowerCase().contains(lowercaseKeyword)) {
        return true;
      }

      try {
        // 匹配拼音全拼
        String pinyin = PinyinHelper.getPinyinE(
          store.name,
          defPinyin: '',
          format: PinyinFormat.WITHOUT_TONE,
        ).toLowerCase();
        if (pinyin.contains(lowercaseKeyword)) {
          return true;
        }
        // 匹配拼音首字母
        String pinyinInitials =
            PinyinHelper.getShortPinyin(store.name).toLowerCase();
        return pinyinInitials.contains(lowercaseKeyword);
      } catch (e) {
        print('Pinyin conversion error: $e');
        return false;
      }
    }).toList();
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

  void toggleFavoriteList() {
    showFavorites.value = !showFavorites.value;
    loadStores(); // 重新加载门店列表
  }

  void toggleFavorite(Store store) {
    store.isFavorite.value = !store.isFavorite.value;
    // TODO: 保存收藏状态到本地存储或服务器
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
    try {
      searchController.removeListener(_onSearchChanged);
      searchController.dispose();
    } catch (e) {
      print('Dispose error: $e');
    }
    super.onClose();
  }
}
