import 'package:get/get.dart';
import '../models/store.dart';
import '../services/store_service.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoriteStoresController extends GetxController {
  final StoreService _storeService = StoreService();
  final RxList<Store> favoriteStores = <Store>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavoriteStores();
  }

  Future<void> loadFavoriteStores() async {
    try {
      isLoading.value = true;
      // TODO: 从本地存储或服务器加载收藏的门店
      favoriteStores.value = await _storeService.getFavoriteStores();
    } catch (e) {
      Get.snackbar('错误', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(Store store) {
    store.isFavorite.value = !store.isFavorite.value;
    if (!store.isFavorite.value) {
      favoriteStores.remove(store);
    }
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
}
