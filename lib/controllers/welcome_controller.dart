import 'package:get/get.dart';
import '../services/unsplash_service.dart';

class WelcomeController extends GetxController {
  final UnsplashService _unsplashService = UnsplashService();
  final RxString imageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    refreshImage();
  }

  /// 刷新背景图片
  Future<void> refreshImage() async {
    try {
      final photo = await _unsplashService.getRandomFoodPhoto();
      imageUrl.value = photo.regularUrl;
    } catch (e) {
      Get.snackbar('错误', '获取图片失败，请重试');
    }
  }

  /// 进入主页
  void onEnterPressed() {
    Get.offAllNamed('/login'); // 修改为导航到登录页面
  }
}
