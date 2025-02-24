import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class RegisterController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  final AuthService _authService = AuthService();

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> handleRegister() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;

      final result = await _authService.register(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (result['success']) {
        Get.snackbar('成功', '注册成功');
        Get.offAllNamed('/login');
      } else {
        Get.snackbar('错误', result['message'] ?? '注册失败，请重试');
      }
    } catch (e) {
      Get.snackbar('错误', '注册失败：$e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (usernameController.text.isEmpty) {
      Get.snackbar('错误', '请输入用户名');
      return false;
    }

    if (emailController.text.isEmpty) {
      Get.snackbar('错误', '请输入邮箱');
      return false;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('错误', '请输入有效的邮箱地址');
      return false;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar('错误', '请输入密码');
      return false;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar('错误', '密码长度至少6位');
      return false;
    }

    if (confirmPasswordController.text != passwordController.text) {
      Get.snackbar('错误', '两次输入的密码不一致');
      return false;
    }

    return true;
  }
}

// 注册响应模型
class RegisterResponse {
  final bool success;
  final String? message;

  RegisterResponse({
    required this.success,
    this.message,
  });
}
