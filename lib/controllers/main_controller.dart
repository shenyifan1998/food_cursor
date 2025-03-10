import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/home_page.dart';
import '../pages/order_page.dart';
import '../pages/cart_page.dart';
import '../pages/profile_page.dart';
import '../controllers/order_controller.dart';

class MainController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

  final List<Widget> pages = [
    const HomePage(),
    const OrderPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void navigateToOrder(bool isSelfPickup) {
    currentIndex.value = 1;
    Get.find<OrderController>().setDeliveryMethod(isSelfPickup);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
