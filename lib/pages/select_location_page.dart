import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/select_location_controller.dart';
import '../models/store.dart';
import '../pages/city_select_page.dart';

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
    return InkWell(
      onTap: () => controller.selectStore(store),
      child: Container(
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '${store.distance}km',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
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
    );
  }
}
