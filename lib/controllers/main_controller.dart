import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
