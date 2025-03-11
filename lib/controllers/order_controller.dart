import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/store_service.dart';
import '../models/store.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/left_side_menu.dart';
import '../models/product.dart';
import 'package:flutter/material.dart';

class OrderController extends GetxController {
  final StoreService _storeService = StoreService();
  final RxString storeName = ''.obs;
  final RxString businessHours = ''.obs;
  final RxBool isSelfPickup = true.obs;
  final RxList<String> promotionImages = <String>[].obs;
  final RxList<LeftSideMenu> menuList = <LeftSideMenu>[].obs;
  final RxInt selectedMenuId = 0.obs;
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> filteredProducts = <Product>[].obs;
  final ScrollController scrollController = ScrollController();
  final ScrollController menuScrollController = ScrollController();
  final RxString currentVisibleType = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // 获取路由参数，设置配送方式
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('isSelfPickup')) {
        isSelfPickup.value = args['isSelfPickup'] as bool;
      }
    }

    // 添加滚动监听器
    scrollController.addListener(onScroll);

    loadSelectedStore();
    loadPromotionImages();

    // 一次性加载所有数据
    loadAllData();
  }

  @override
  void onClose() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    menuScrollController.dispose();
    super.onClose();
  }

  Future<void> loadSelectedStore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storeJson = prefs.getString('selected_store');
      if (storeJson != null) {
        final store = Store.fromJson(jsonDecode(storeJson));
        storeName.value = store.name;
        businessHours.value = store.businessHours;
      }
    } catch (e) {
      print('加载门店信息失败: $e');
    }
  }

  void setDeliveryMethod(bool isSelfPickup) {
    this.isSelfPickup.value = isSelfPickup;
  }

  Future<void> loadPromotionImages() async {
    // 使用更可靠的图片URL
    promotionImages.value = [
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1512568400610-62da28bc8a13?w=800&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1501959915551-4e8d30928317?w=800&auto=format&fit=crop',
    ];
  }

  Future<void> loadMenuList() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/menu/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['result'] == 'SUCCESS') {
          final List<dynamic> menuData = data['data'];
          menuList.value =
              menuData.map((item) => LeftSideMenu.fromJson(item)).toList();
          if (menuList.isNotEmpty) {
            selectedMenuId.value = menuList[0].id;
            // 加载第一个分类的商品
            loadProductsByType(menuList[0].type);
          }
        }
      } else {
        // 使用模拟数据
        menuList.value = [
          LeftSideMenu(id: 1, type: 'new', typeName: '新品种草', orderNum: 1),
          LeftSideMenu(id: 2, type: 'super', typeName: '超级蔬食', orderNum: 2),
          LeftSideMenu(id: 3, type: 'light', typeName: '轻乳茶', orderNum: 3),
          LeftSideMenu(id: 4, type: 'signature', typeName: '招牌奶茶', orderNum: 4),
          LeftSideMenu(id: 5, type: 'member', typeName: '会员随心配', orderNum: 5),
          LeftSideMenu(id: 6, type: 'fresh', typeName: '清爽鲜果茶', orderNum: 6),
        ];
        if (menuList.isNotEmpty) {
          selectedMenuId.value = menuList[0].id;
          loadProducts(); // 加载所有商品，然后筛选
        }
      }
    } catch (e) {
      print('加载菜单失败: $e');
      // 使用模拟数据
      menuList.value = [
        LeftSideMenu(id: 1, type: 'new', typeName: '新品种草', orderNum: 1),
        LeftSideMenu(id: 2, type: 'super', typeName: '超级蔬食', orderNum: 2),
        LeftSideMenu(id: 3, type: 'light', typeName: '轻乳茶', orderNum: 3),
        LeftSideMenu(id: 4, type: 'signature', typeName: '招牌奶茶', orderNum: 4),
        LeftSideMenu(id: 5, type: 'member', typeName: '会员随心配', orderNum: 5),
        LeftSideMenu(id: 6, type: 'fresh', typeName: '清爽鲜果茶', orderNum: 6),
      ];
      if (menuList.isNotEmpty) {
        selectedMenuId.value = menuList[0].id;
        loadProducts(); // 加载所有商品，然后筛选
      }
    }
  }

  // 根据类型加载商品
  Future<void> loadProductsByType(String type) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/products/type/$type'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['result'] == 'SUCCESS') {
          final List<dynamic> productData = data['data'];
          filteredProducts.value =
              productData.map((item) => Product.fromJson(item)).toList();
        }
      } else {
        // 使用模拟数据
        filterProductsByMenu(selectedMenuId.value);
      }
    } catch (e) {
      print('根据类型加载商品失败: $e');
      // 使用模拟数据
      filterProductsByMenu(selectedMenuId.value);
    }
  }

  Future<void> loadProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/products'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['result'] == 'SUCCESS') {
          final List<dynamic> productData = data['data'];
          products.value =
              productData.map((item) => Product.fromJson(item)).toList();

          // 如果菜单已加载，则筛选商品
          if (menuList.isNotEmpty && selectedMenuId.value > 0) {
            filterProductsByMenu(selectedMenuId.value);
          } else if (menuList.isNotEmpty) {
            // 默认选择第一个菜单
            selectedMenuId.value = menuList[0].id;
            filterProductsByMenu(selectedMenuId.value);
          }
        }
      } else {
        // 使用模拟数据（保留原有的模拟数据作为备份）
        products.value = [
          Product(
            id: 1,
            name: '乌漆嘛黑',
            description: '优选甜度≥8°的完熟桑葚颗颗手剥，搭配香水柠檬、风梨',
            tags: ['桑葚', '草莓', '香水柠檬', '风梨'],
            originalPrice: 15.0,
            discountPrice: 13.2,
            imageUrl:
                'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500&auto=format&fit=crop',
            menuType: 'new',
          ),
          Product(
            id: 2,
            name: '三重莓果·晚安杯',
            description: '优选三种新鲜[超级食物]——蓝莓、草莓、桑葚',
            tags: ['桑葚', '草莓', '蓝莓'],
            originalPrice: 22.0,
            discountPrice: 19.36,
            imageUrl:
                'https://images.unsplash.com/photo-1546173159-315724a31696?w=500&auto=format&fit=crop',
            menuType: 'new',
          ),
          Product(
            id: 3,
            name: '芝芝莓莓',
            description: '选用浓郁芝士与新鲜草莓调制而成',
            tags: ['芝士', '草莓'],
            originalPrice: 19.0,
            discountPrice: 16.9,
            imageUrl:
                'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=500&auto=format&fit=crop',
            menuType: 'light',
          ),
        ];

        if (menuList.isEmpty) {
          menuList.value = [
            LeftSideMenu(id: 1, type: 'new', typeName: '新品种草', orderNum: 1),
            LeftSideMenu(id: 2, type: 'super', typeName: '超级蔬食', orderNum: 2),
            LeftSideMenu(id: 3, type: 'light', typeName: '轻乳茶', orderNum: 3),
            LeftSideMenu(
                id: 4, type: 'signature', typeName: '招牌奶茶', orderNum: 4),
            LeftSideMenu(id: 5, type: 'member', typeName: '会员随心配', orderNum: 5),
            LeftSideMenu(id: 6, type: 'fresh', typeName: '清爽鲜果茶', orderNum: 6),
          ];
          if (menuList.isNotEmpty) {
            selectedMenuId.value = menuList[0].id;
          }
        }

        filterProductsByMenu(selectedMenuId.value);
      }
    } catch (e) {
      print('加载商品失败: $e');
      // 使用模拟数据（保留原有的模拟数据作为备份）
      products.value = [
        Product(
          id: 1,
          name: '乌漆嘛黑',
          description: '优选甜度≥8°的完熟桑葚颗颗手剥，搭配香水柠檬、风梨',
          tags: ['桑葚', '草莓', '香水柠檬', '风梨'],
          originalPrice: 15.0,
          discountPrice: 13.2,
          imageUrl:
              'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=500&auto=format&fit=crop',
          menuType: 'new',
        ),
        Product(
          id: 2,
          name: '三重莓果·晚安杯',
          description: '优选三种新鲜[超级食物]——蓝莓、草莓、桑葚',
          tags: ['桑葚', '草莓', '蓝莓'],
          originalPrice: 22.0,
          discountPrice: 19.36,
          imageUrl:
              'https://images.unsplash.com/photo-1546173159-315724a31696?w=500&auto=format&fit=crop',
          menuType: 'new',
        ),
        Product(
          id: 3,
          name: '芝芝莓莓',
          description: '选用浓郁芝士与新鲜草莓调制而成',
          tags: ['芝士', '草莓'],
          originalPrice: 19.0,
          discountPrice: 16.9,
          imageUrl:
              'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=500&auto=format&fit=crop',
          menuType: 'light',
        ),
      ];

      if (menuList.isEmpty) {
        menuList.value = [
          LeftSideMenu(id: 1, type: 'new', typeName: '新品种草', orderNum: 1),
          LeftSideMenu(id: 2, type: 'super', typeName: '超级蔬食', orderNum: 2),
          LeftSideMenu(id: 3, type: 'light', typeName: '轻乳茶', orderNum: 3),
          LeftSideMenu(id: 4, type: 'signature', typeName: '招牌奶茶', orderNum: 4),
          LeftSideMenu(id: 5, type: 'member', typeName: '会员随心配', orderNum: 5),
          LeftSideMenu(id: 6, type: 'fresh', typeName: '清爽鲜果茶', orderNum: 6),
        ];
        if (menuList.isNotEmpty) {
          selectedMenuId.value = menuList[0].id;
        }
      }

      filterProductsByMenu(selectedMenuId.value);
    }
  }

  void filterProductsByMenu(int menuId) {
    selectedMenuId.value = menuId;
    final selectedMenu = menuList.firstWhere((menu) => menu.id == menuId);
    filteredProducts.value = products
        .where((product) => product.menuType == selectedMenu.type)
        .toList();
  }

  // 修改滚动监听函数，以更准确地检测当前可见的菜单类型
  void onScroll() {
    if (filteredProducts.isEmpty) return;

    // 获取当前滚动位置和视口高度
    final offset = scrollController.offset;
    final viewportHeight = scrollController.position.viewportDimension;

    // 计算标题高度和产品项高度
    const headerHeight = 50.0;
    const productItemHeight = 132.0; // 根据实际产品项高度调整

    // 当前可见区域的顶部和底部位置
    final topPosition = offset;
    final bottomPosition = offset + viewportHeight;

    // 跟踪当前位置所处的菜单类型
    String? visibleType;
    double currentPosition = 0;
    String? previousType;

    // 遍历所有产品，计算每个产品的位置
    for (int i = 0; i < filteredProducts.length; i++) {
      final product = filteredProducts[i];

      // 如果是新的菜单类型，添加标题高度
      if (i == 0 || filteredProducts[i - 1].menuType != product.menuType) {
        previousType = i > 0 ? filteredProducts[i - 1].menuType : null;

        // 添加标题高度
        currentPosition += headerHeight;

        // 如果标题在可见区域内
        if (currentPosition > topPosition && currentPosition < bottomPosition) {
          visibleType = product.menuType;
          break;
        }
      }

      // 添加产品项高度
      currentPosition += productItemHeight;

      // 如果产品在可见区域内
      if (currentPosition > topPosition && currentPosition <= bottomPosition) {
        visibleType = product.menuType;
        break;
      }
    }

    // 如果没有找到可见类型，且滚动位置接近顶部，使用第一个类型
    if (visibleType == null &&
        offset < headerHeight &&
        filteredProducts.isNotEmpty) {
      visibleType = filteredProducts[0].menuType;
    }
    // 如果仍未找到，且有前一个类型，使用前一个类型
    else if (visibleType == null && previousType != null) {
      visibleType = previousType;
    }

    // 如果找到可见类型且与当前不同，更新菜单选中状态
    if (visibleType != null && visibleType != currentVisibleType.value) {
      currentVisibleType.value = visibleType;

      // 查找对应的菜单ID
      final menuItem =
          menuList.firstWhereOrNull((menu) => menu.type == visibleType);
      if (menuItem != null && menuItem.id != selectedMenuId.value) {
        // 更新选中的菜单ID
        selectedMenuId.value = menuItem.id;

        // 滚动左侧菜单到可见位置
        final menuIndex = menuList.indexWhere((menu) => menu.id == menuItem.id);
        if (menuIndex >= 0) {
          // 计算目标滚动位置
          final maxScroll = menuScrollController.position.maxScrollExtent;
          final targetScroll = menuIndex * 50.0; // 假设每个菜单项高度为50

          // 确保不会滚动超出范围
          final safeScroll = targetScroll.clamp(0.0, maxScroll);

          // 只有当需要滚动时才执行滚动
          if ((menuScrollController.offset - safeScroll).abs() > 10) {
            menuScrollController.animateTo(
              safeScroll,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      }
    }
  }

  // 一次性加载所有数据
  Future<void> loadAllData() async {
    await loadMenuList();
    await loadAllProducts();
  }

  // 加载所有商品，不按类型筛选
  Future<void> loadAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/products'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['result'] == 'SUCCESS') {
          final List<dynamic> productData = data['data'];
          products.value =
              productData.map((item) => Product.fromJson(item)).toList();

          // 按类型对商品进行分组
          final groupedProducts = <String, List<Product>>{};
          for (final product in products) {
            if (!groupedProducts.containsKey(product.menuType)) {
              groupedProducts[product.menuType] = [];
            }
            groupedProducts[product.menuType]!.add(product);
          }

          // 将分组后的商品按照左侧菜单的顺序排列
          final allProducts = <Product>[];
          for (final menu in menuList) {
            if (groupedProducts.containsKey(menu.type)) {
              allProducts.addAll(groupedProducts[menu.type]!);
            }
          }

          // 更新筛选后的商品列表
          filteredProducts.value = allProducts;

          // 如果有菜单项，默认选中第一个
          if (menuList.isNotEmpty) {
            selectedMenuId.value = menuList[0].id;
          }
        }
      } else {
        // 使用模拟数据
        // ...现有的模拟数据代码
      }
    } catch (e) {
      print('加载商品失败: $e');
      // 使用模拟数据
      // ...现有的模拟数据代码
    }
  }

  // 修改选择菜单的方法，确保滚动到正确位置
  void selectMenu(int menuId) {
    if (selectedMenuId.value == menuId) return;

    selectedMenuId.value = menuId;
    final selectedMenu = menuList.firstWhere((menu) => menu.id == menuId);

    // 查找该类型的第一个商品在列表中的位置
    final index =
        filteredProducts.indexWhere((p) => p.menuType == selectedMenu.type);
    if (index >= 0) {
      // 滚动到该位置，但确保不会超出范围
      final maxScroll = scrollController.position.maxScrollExtent;
      final targetScroll = index * 200.0; // 假设每个商品项高度约为200像素

      // 确保不会滚动超出范围
      final safeScroll = targetScroll.clamp(0.0, maxScroll);

      scrollController.animateTo(
        safeScroll,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
