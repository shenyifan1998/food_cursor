import 'package:get/get.dart';
import '../services/unsplash_service.dart';

class HomeController extends GetxController {
  final UnsplashService _unsplashService = UnsplashService();
  final RxList<String> imageUrls = <String>[].obs;
  final RxString currentLocation = '唐山爱琴海店'.obs;
  final RxString distance = '1.27'.obs;
  final RxInt couponCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshImages();
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
