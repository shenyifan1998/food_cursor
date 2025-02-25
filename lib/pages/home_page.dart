import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'select_location_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: controller.refreshImages,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 使用 Stack 来实现悬浮效果
                  Stack(
                    children: [
                      // 轮播图
                      _buildCarousel(controller),

                      // 悬浮的地图按钮 - 调整位置和尺寸
                      Positioned(
                        top: 48,
                        left: MediaQuery.of(context).size.width *
                            0.25, // 左边距为屏幕宽度的1/4
                        right: MediaQuery.of(context).size.width *
                            0.25, // 右边距为屏幕宽度的1/4
                        child: SizedBox(
                          height: 250 / 8, // 轮播图高度的1/8
                          child: _buildLocationButton(controller),
                        ),
                      ),
                    ],
                  ),

                  // 3. 用户信息和优惠券入口
                  _buildUserInfoSection(controller),

                  // 4. 取餐方式
                  _buildPickupMethods(),

                  // 5. 功能区
                  _buildFunctionArea(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 修改地图按钮组件样式
  Widget _buildLocationButton(HomeController controller) {
    return Material(
      color: Colors.black.withOpacity(0.6),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () => Get.to(() => const SelectLocationPage()),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          constraints: const BoxConstraints(minHeight: 32), // 添加最小高度约束
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: Color(0xFF3EB489),
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Row(
                  // 将 Column 改为 Row
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        controller.currentLocation.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${controller.distance.value}km',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.8),
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 修改轮播图组件，移除上边距
  Widget _buildCarousel(HomeController controller) {
    return Obx(() => controller.imageUrls.isEmpty
        ? const SizedBox(
            height: 250, // 增加高度以适应悬浮按钮
            child: Center(child: CircularProgressIndicator()),
          )
        : SizedBox(
            height: 250, // 增加高度以适应悬浮按钮
            child: Swiper(
              itemBuilder: (context, index) {
                return Image.network(
                  controller.imageUrls[index],
                  fit: BoxFit.cover,
                );
              },
              itemCount: controller.imageUrls.length,
              autoplay: true,
              duration: 300,
              autoplayDelay: 3000,
              pagination: const SwiperPagination(),
            ),
          ));
  }

  // 3. 用户信息和优惠券入口
  Widget _buildUserInfoSection(HomeController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('https://via.placeholder.com/50'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '下午好，用户名',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${controller.couponCount.value}张优惠券待使用',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // 跳转到优惠券页面
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3EB489),
            ),
            child: const Text('立即使用'),
          ),
        ],
      ),
    );
  }

  // 4. 取餐方式
  Widget _buildPickupMethods() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildPickupMethodCard(
              icon: Icons.store,
              title: '到店取餐',
              subtitle: '在线点，到店取',
              onTap: () {
                // 处理到店取餐
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildPickupMethodCard(
              icon: Icons.delivery_dining,
              title: '外卖配送',
              subtitle: '最快30分钟送达',
              onTap: () {
                // 处理外卖配送
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF3EB489)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 5. 功能区
  Widget _buildFunctionArea() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '常用功能',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildFunctionItem(Icons.shopping_bag, '签到'),
              _buildFunctionItem(Icons.school, '菜篮子'),
              _buildFunctionItem(Icons.group, '一起吃'),
              _buildFunctionItem(Icons.location_on, '食谱'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 32, color: const Color(0xFF3EB489)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
