import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/unsplash_service.dart';

class LoginController extends GetxController {
  final UnsplashService _unsplashService = UnsplashService();
  final RxString backgroundUrl = ''.obs;
  final RxBool isPasswordVisible = false.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadBackgroundImage();
  }

  @override
  void onClose() {
    print('onClose');
    // emailController.dispose();
    // passwordController.dispose();
    // super.onClose();
  }

  Future<void> _loadBackgroundImage() async {
    try {
      final photo = await _unsplashService.getRandomFoodPhoto();
      backgroundUrl.value = photo.regularUrl;
    } catch (e) {
      Get.snackbar('错误', '获取背景图片失败');
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void handleWeChatLogin() {
    // TODO: 实现微信登录
    Get.snackbar('提示', '微信登录功能开发中');
  }

  void handleAppleLogin() {
    // TODO: 实现苹果登录
    Get.snackbar('提示', '苹果登录功能开发中');
  }

  void handleLogin() {
    // TODO: 实现邮箱登录
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('错误', '请输入邮箱和密码');
      return;
    }
    // 实现登录逻辑
    Get.offAllNamed('/main');
  }

  void handleForgotPassword() {
    // TODO: 实现忘记密码
    Get.snackbar('提示', '忘记密码功能开发中');
  }

  void handleRegister() {
    // TODO: 跳转到注册页面
    Get.toNamed('/register');
  }
}
