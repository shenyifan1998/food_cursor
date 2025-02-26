import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_stores_controller.dart';
import '../models/store.dart';

class FavoriteStoresPage extends StatelessWidget {
  const FavoriteStoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoriteStoresController>(
      init: FavoriteStoresController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('收藏的门店'),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0.5,
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.favoriteStores.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/no_favorite.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '您暂没有常用/收藏的门店~',
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              itemCount: controller.favoriteStores.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return _buildStoreItem(
                  controller.favoriteStores[index],
                  controller,
                );
              },
            );
          }),
        );
      },
    );
  }

  Widget _buildStoreItem(Store store, FavoriteStoresController controller) {
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
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
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
    );
  }
}
