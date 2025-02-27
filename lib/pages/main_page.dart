import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';
import '../controllers/auth_controller.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(),
      builder: (controller) {
        return Scaffold(
          body: PageView(
            controller: controller.pageController,
            onPageChanged: controller.changePage,
            children: const [
              HomePage(),
              CategoryPage(),
              FavoritePage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: Obx(() => BottomNavigationBar(
                currentIndex: controller.currentIndex.value,
                onTap: controller.changePage,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: const Color(0xFF3EB489),
                unselectedItemColor: Colors.grey,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: '首页',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.category),
                    label: '分类',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: '收藏',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: '我的',
                  ),
                ],
              )),
        );
      },
    );
  }

  Widget _buildUserSection() {
    final authController = Get.find<AuthController>();

    return Obx(() {
      if (authController.isLoggedIn.value) {
        return ListTile(
          leading: const Icon(Icons.person),
          title: Text('欢迎，${authController.username.value}'),
          trailing: IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => authController.logout(),
          ),
        );
      } else {
        return ListTile(
          leading: const Icon(Icons.login),
          title: const Text('登录/注册'),
          onTap: () => Get.toNamed('/login'),
        );
      }
    });
  }
}
