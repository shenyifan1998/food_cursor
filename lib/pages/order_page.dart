import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import '../models/product.dart';

// 将 _SliverHeaderDelegate 类移到顶层
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 计算透明度，当标题被推出时逐渐变透明
    final double opacity = 1.0 - (shrinkOffset / maxExtent).clamp(0.0, 1.0);

    return Opacity(
      opacity: opacity,
      child: SizedBox.expand(child: child),
    );
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

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
              SizedBox(
                height: 180,
                width: double.infinity,
                child: _buildCarousel(controller),
              ),

              // 主体内容区域
              Expanded(
                child: Row(
                  children: [
                    // 左侧菜单
                    SizedBox(
                      width: 100,
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
      child: Obx(() => ListView.builder(
            controller: controller.menuScrollController,
            padding: EdgeInsets.zero,
            itemCount: controller.menuList.length,
            itemBuilder: (context, index) {
              final menu = controller.menuList[index];
              return Obx(() {
                final isSelected = menu.id == controller.selectedMenuId.value;
                return InkWell(
                  onTap: () {
                    // 点击时不加载数据，只滚动到对应位置
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
              });
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
                Icon(Icons.no_food, size: 64, color: Colors.grey[400]),
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
        : NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              // 当滚动结束时，检查是否需要更新左侧菜单
              if (notification is ScrollEndNotification) {
                controller.onScroll();
              }
              return false;
            },
            child: CustomScrollView(
              controller: controller.scrollController,
              slivers: _buildProductSlivers(controller),
            ),
          ));
  }

  // 构建产品分组的Sliver列表
  List<Widget> _buildProductSlivers(OrderController controller) {
    final slivers = <Widget>[];
    final products = controller.filteredProducts;

    // 记录当前处理的菜单类型
    String? currentType;
    // 记录当前类型的产品索引范围
    int startIndex = 0;

    // 遍历所有产品，按类型分组
    for (int i = 0; i <= products.length; i++) {
      // 如果到达列表末尾或者遇到新的菜单类型
      if (i == products.length ||
          (i > 0 && products[i].menuType != currentType)) {
        // 如果有当前类型的产品，则添加该类型的标题和产品列表
        if (currentType != null) {
          // 添加固定的分类标题
          slivers.add(
            SliverPersistentHeader(
              pinned: true, // 固定在顶部
              floating: true, // 允许浮动，这样当新标题出现时，旧标题会被推出
              delegate: _SliverHeaderDelegate(
                minHeight: 40, // 减小高度，避免过多空白
                maxHeight: 40,
                child: Container(
                  color: Colors.white, // 使用白色背景，更符合设计
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16), // 只保留水平内边距
                  alignment: Alignment.centerLeft, // 确保文字垂直居中
                  child: Text(
                    _getCategoryTitle(currentType),
                    style: const TextStyle(
                      fontSize: 16, // 稍微减小字体大小
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );

          // 添加该类型的产品列表
          slivers.add(
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildProductItem(products[startIndex + index]);
                },
                childCount: i - startIndex,
              ),
            ),
          );
        }

        // 如果不是列表末尾，更新当前类型和起始索引
        if (i < products.length) {
          currentType = products[i].menuType;
          startIndex = i;
        }
      } else if (i == 0) {
        // 第一个产品，初始化当前类型
        currentType = products[0].menuType;
      }
    }

    // 添加底部空白
    slivers.add(
      const SliverToBoxAdapter(
        child: SizedBox(height: 100),
      ),
    );

    return slivers;
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
                    // 价格信息
                    Text(
                      '¥${product.discountPrice.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red[400],
                        fontWeight: FontWeight.bold,
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
                    // 添加按钮
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

  String _getCategoryTitle(String menuType) {
    switch (menuType) {
      case 'new':
        return '新品种草';
      case 'super':
        return '超级蔬食';
      case 'light':
        return '轻乳茶';
      case 'signature':
        return '招牌奶茶';
      case 'member':
        return '会员随心配';
      case 'fresh':
        return '清爽鲜果茶';
      default:
        return '推荐商品';
    }
  }
}
