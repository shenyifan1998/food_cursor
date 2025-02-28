import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/select_location_controller.dart';
import '../models/store.dart';
import '../pages/city_select_page.dart';
import '../pages/favorite_stores_page.dart';
import '../controllers/auth_controller.dart';

class SelectLocationPage extends StatelessWidget {
  const SelectLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectLocationController>(
      init: SelectLocationController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: controller.selectCity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => Text(controller.selectedCity.value)),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0.5,
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () => Get.to(() => const FavoriteStoresPage()),
              ),
            ],
          ),
          body: Column(
            children: [
              // 搜索框
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: '搜索店铺名称或地址',
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFF999999)),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              // 店铺列表
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final storeList = controller.isSearching.value
                      ? controller.searchResults
                      : controller.stores;

                  if (storeList.isEmpty) {
                    return const Center(
                      child: Text('暂无门店'),
                    );
                  }

                  return ListView.separated(
                    itemCount: storeList.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return _buildStoreItem(storeList[index], controller);
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoreItem(Store store, SelectLocationController controller) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => controller.selectStore(store),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      store.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Obx(() => Icon(
                          store.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: store.isFavorite ? Colors.red : Colors.grey,
                        )),
                    onPressed: () => controller.toggleFavorite(store),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                store.address,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    store.businessHours,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: () => controller.callStore(store),
                    iconSize: 20,
                    color: Colors.black54,
                  ),
                  IconButton(
                    icon: const Icon(Icons.navigation),
                    onPressed: () => controller.navigateToStore(store),
                    iconSize: 20,
                    color: Colors.black54,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleFavoriteList() {
    final authController = Get.find<AuthController>();
    final controller = Get.find<SelectLocationController>();
    if (controller.showFavorites.value == false &&
        !authController.isLoggedIn.value) {
      // 如果要切换到收藏列表但未登录，则跳转到登录页面
      Get.toNamed('/login');
      return;
    }
    controller.toggleFavoriteList();
  }
}
