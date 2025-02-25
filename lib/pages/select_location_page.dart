import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/select_location_controller.dart';
import '../models/store.dart';

class SelectLocationPage extends StatelessWidget {
  const SelectLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectLocationController>(
      init: SelectLocationController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('选择门店'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            actions: [
              TextButton(
                onPressed: () {
                  // 切换到收藏列表
                  controller.toggleFavorite();
                },
                child: Obx(() => Text(
                      controller.showFavorites.value ? '附近门店' : '常用/收藏',
                      style: const TextStyle(color: Colors.black54),
                    )),
              ),
            ],
          ),
          body: Column(
            children: [
              // 1. 搜索区域
              _buildSearchArea(controller),

              // 2. 展开地图按钮
              _buildExpandMapButton(),

              // 3. 门店列表
              Expanded(
                child: _buildStoreList(controller),
              ),
            ],
          ),
        );
      },
    );
  }

  // 1. 搜索区域
  Widget _buildSearchArea(SelectLocationController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        children: [
          // 城市选择和搜索框
          Row(
            children: [
              // 城市选择按钮
              InkWell(
                onTap: controller.selectCity,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => Text(controller.selectedCity.value)),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 搜索框
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    decoration: const InputDecoration(
                      hintText: '搜索门店/地点',
                      border: InputBorder.none,
                      icon: Icon(Icons.search),
                    ),
                    onChanged: controller.onSearchChanged,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. 展开地图按钮
  Widget _buildExpandMapButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      child: TextButton(
        onPressed: () {
          // 展开地图
        },
        child: const Text('展开地图'),
      ),
    );
  }

  // 3. 门店列表
  Widget _buildStoreList(SelectLocationController controller) {
    return Obx(() => ListView.separated(
          itemCount: controller.stores.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final store = controller.stores[index];
            return _buildStoreItem(store, controller);
          },
        ));
  }

  // 门店列表项
  Widget _buildStoreItem(Store store, SelectLocationController controller) {
    return InkWell(
      onTap: () => controller.selectStore(store),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        store.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (store.isOpen)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '营业中',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      if (store.supportsTakeout)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '可外卖',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
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
                  const SizedBox(height: 4),
                  Text(
                    '营业时间：${store.businessHours}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${store.distance}km',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
          ],
        ),
      ),
    );
  }
}
