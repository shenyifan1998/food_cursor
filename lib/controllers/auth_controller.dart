import 'package:get/get.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final RxBool isLoggedIn = false.obs;
  final RxString username = ''.obs;
  final RxInt userId = 0.obs;
  final RxString token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // 检查登录状态
  Future<void> checkLoginStatus() async {
    final loggedIn = await _authService.isLoggedIn();
    if (loggedIn) {
      isLoggedIn.value = true;
      username.value = await _authService.getUsername();
      userId.value = await _authService.getUserId();
      token.value = await _authService.getToken();
    } else {
      isLoggedIn.value = false;
      username.value = '';
      userId.value = 0;
      token.value = '';
    }
  }

  // 登录
  Future<void> login(String username, String password) async {
    final result = await _authService.login(username, password);
    this.username.value = result['username'];
    userId.value = result['userId'];
    token.value = result['token'];
    isLoggedIn.value = true;

    // 登录成功后跳转到主页
    Get.offAllNamed('/main');
  }

  // 注册
  Future<void> register(String username, String email, String password) async {
    await _authService.register(username, email, password);
    // 注册成功后自动登录
    await login(username, password);
  }

  // 退出登录
  Future<void> logout() async {
    await _authService.logout();
    isLoggedIn.value = false;
    username.value = '';
    userId.value = 0;
    token.value = '';

    // 退出登录后跳转到登录页
    Get.offAllNamed('/login');
  }
}
