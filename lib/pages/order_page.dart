import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import '../models/product.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      init: OrderController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // 顶部门店信息栏
              Container(
                padding: const EdgeInsets.fromLTRB(2, 48, 2, 12),
                color: Colors.white,
                child: Row(
                  children: [
                    // 门店信息部分
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          Get.toNamed('/select-store');
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.store,
                                size: 20, color: Colors.blue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Obx(() => Text(
                                              controller.storeName.value,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ),
                                      const Icon(Icons.chevron_right, size: 18),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '距离您2.66km',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 提货方式切换
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            // 自取按钮
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.setDeliveryMethod(true),
                                child: Obx(() => Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: controller.isSelfPickup.value
                                            ? Colors.blue
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Text(
                                        '自取',
                                        style: TextStyle(
                                          color: controller.isSelfPickup.value
                                              ? Colors.white
                                              : Colors.grey[700],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                            // 外卖按钮
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    controller.setDeliveryMethod(false),
                                child: Obx(() => Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: !controller.isSelfPickup.value
                                            ? Colors.blue
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Text(
                                        '外卖',
                                        style: TextStyle(
                                          color: !controller.isSelfPickup.value
                                              ? Colors.white
                                              : Colors.grey[700],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 替换促销信息条为搜索框
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.grey[100],
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: InkWell(
                    onTap: () {
                      // 跳转到搜索页面
                      Get.toNamed('/search');
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(Icons.search, color: Colors.grey[400], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '搜索商品',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 轮播图
              Container(
                height: 180,
                width: double.infinity,
                child: _buildCarousel(controller),
              ),

              // 导航标签
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '门店菜单',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '用券下单',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 商品列表区域
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 左侧菜单
                    SizedBox(
                      width: 90,
                      child: _buildLeftSideMenu(controller),
                    ),
                    // 右侧商品列表
                    Expanded(
                      child: _buildProductList(controller),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCarousel(OrderController controller) {
    return Obx(() => Swiper(
          itemBuilder: (context, index) {
            return Image.network(
              controller.promotionImages[index],
              fit: BoxFit.cover,
            );
          },
          itemCount: controller.promotionImages.length,
          pagination: const SwiperPagination(
            builder: DotSwiperPaginationBuilder(
              activeColor: Colors.blue,
              color: Colors.grey,
            ),
          ),
          autoplay: true,
          duration: 300,
        ));
  }

  Widget _buildLeftSideMenu(OrderController controller) {
    return Container(
      color: Colors.grey[100],
      child: Obx(() => controller.menuList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: controller.menuScrollController,
              padding: EdgeInsets.zero,
              itemCount: controller.menuList.length,
              itemBuilder: (context, index) {
                final menu = controller.menuList[index];
                final isSelected = menu.id == controller.selectedMenuId.value;

                return InkWell(
                  onTap: () {
                    controller.selectMenu(menu.id);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Text(
                      menu.typeName,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.blue : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            )),
    );
  }

  Widget _buildProductList(OrderController controller) {
    return Obx(() => controller.filteredProducts.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.no_food, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  '暂无商品',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        : ListView.separated(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(0),
            itemCount: controller.filteredProducts.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final product = controller.filteredProducts[index];

              // 如果是第一个商品或者与前一个商品的类型不同，显示分类标题
              if (index == 0 ||
                  controller.filteredProducts[index - 1].menuType !=
                      product.menuType) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 分类标题
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1563729784474-d77dbb933a9e?w=800&auto=format&fit=crop',
                          ),
                          fit: BoxFit.cover,
                          opacity: 0.7,
                        ),
                      ),
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildProductItem(product),
                  ],
                );
              }

              return _buildProductItem(product);
            },
          ));
  }

  Widget _buildProductItem(Product product) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 商品图片
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child:
                      Icon(Icons.image_not_supported, color: Colors.grey[400]),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          // 商品信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 商品名称
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // 标签
                Wrap(
                  spacing: 8,
                  children: product.tags
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                // 描述
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // 价格和添加按钮
                Row(
                  children: [
                    Text(
                      '券后价 ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[400],
                      ),
                    ),
                    Text(
                      '¥${product.discountPrice.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' 起',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[400],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '¥${product.originalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
