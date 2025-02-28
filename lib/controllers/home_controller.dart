import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/store.dart';
import '../services/store_service.dart';
import 'dart:convert';
import '../services/unsplash_service.dart';

class HomeController extends GetxController {
  final UnsplashService _unsplashService = UnsplashService();
  final StoreService _storeService = StoreService();
  final RxString selectedStoreName = '选择门店'.obs;
  final RxString selectedStoreDistance = ''.obs;
  final RxList<String> imageUrls = <String>[].obs;
  final RxInt couponCount = 0.obs; // 添加优惠券数量

  @override
  void onInit() {
    super.onInit();
    loadSelectedStore();
    loadDefaultStore();
    refreshImages();
  }

  // 加载默认门店（当前城市的第一个门店）
  Future<void> loadDefaultStore() async {
    if (selectedStoreName.value != '选择门店') return;

    try {
      final stores = await _storeService.getStoresByCity('130200');
      if (stores.isNotEmpty) {
        selectedStoreName.value = stores[0].name;
        if (stores[0].distance != null) {
          selectedStoreDistance.value =
              '${stores[0].distance!.toStringAsFixed(2)}km';
        }
      }
    } catch (e) {
      print('加载默认门店失败: $e');
    }
  }

  // 从本地存储加载上次选择的门店
  Future<void> loadSelectedStore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storeJson = prefs.getString('selected_store');
      if (storeJson != null) {
        final store = Store.fromJson(jsonDecode(storeJson));
        selectedStoreName.value = store.name;
        if (store.distance != null) {
          selectedStoreDistance.value =
              '${store.distance!.toStringAsFixed(2)}km';
        }
      }
    } catch (e) {
      print('加载选中门店失败: $e');
    }
  }

  // 保存选中的门店
  Future<void> saveSelectedStore(Store store) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_store', jsonEncode(store.toJson()));
      selectedStoreName.value = store.name;
      selectedStoreDistance.value = store.distance != null
          ? '${store.distance!.toStringAsFixed(2)}km'
          : '';
    } catch (e) {
      print('保存选中门店失败: $e');
    }
  }

   Future<void> refreshImages() async {
       try {
         List<String> urls = [];
         for (int i = 0; i < 3; i++) {
           final photo = await _unsplashService.getRandomFoodPhoto();
           urls.add(photo.regularUrl);
         }
         imageUrls.value = urls;
       } catch (e) {
         Get.snackbar('错误', '获取图片失败');
       }
     }
   }
