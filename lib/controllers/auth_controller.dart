import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  final _token = ''.obs;

  String get token => _token.value;

  @override
  void onInit() {
    super.onInit();
    loadToken();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token.value = prefs.getString('token') ?? '';
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _token.value = token;
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token.value = '';
  }

  bool get isLoggedIn => token.isNotEmpty;
}
