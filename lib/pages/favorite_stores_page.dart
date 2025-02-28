import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_stores_controller.dart';
import '../models/store.dart';

class FavoriteStoresPage extends StatelessWidget {
  const FavoriteStoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoriteStoresController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.stores.isEmpty) {
          return const Center(child: Text('暂无收藏的门店'));
        }

        return ListView.builder(
          itemCount: controller.stores.length,
          itemBuilder: (context, index) {
            final store = controller.stores[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(store.name),
                subtitle: Text(store.address),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () => controller.removeFavorite(store),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
