import 'package:get/get.dart';
import '../models/store.dart';
import '../services/store_service.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoriteStoresController extends GetxController {
  final StoreService _storeService = StoreService();
  final RxList<Store> stores = <Store>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavoriteStores();
  }

  Future<void> loadFavoriteStores() async {
    try {
      isLoading.value = true;
      final favoriteStores = await _storeService.getFavoriteStores();
      stores.value = favoriteStores;
    } catch (e) {
      Get.snackbar('错误', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFavorite(Store store) async {
    try {
      await _storeService.removeFavorite(store.id);
      stores.remove(store);
      Get.snackbar('成功', '已取消收藏');
    } catch (e) {
      Get.snackbar('错误', e.toString());
    }
  }

  void toggleFavorite(Store store) {
    store.isFavorite = !store.isFavorite;
    if (!store.isFavorite) {
      stores.remove(store);
    }
    // TODO: 保存收藏状态到本地存储或服务器
  }

  void selectStore(Store store) {
    Get.back(result: store);
  }

  Future<void> callStore(Store store) async {
    if (store.phone?.isEmpty ?? true) {
      Get.snackbar('错误', '该门店暂无联系电话');
      return;
    }

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: store.phone!,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        Get.snackbar('错误', '无法拨打电话：${store.phone}');
      }
    } catch (e) {
      Get.snackbar('错误', '拨打电话失败：${e.toString()}');
    }
  }

  Future<void> navigateToStore(Store store) async {
    // TODO: 实现导航功能
    Get.snackbar('提示', '导航功能开发中');
  }
}
