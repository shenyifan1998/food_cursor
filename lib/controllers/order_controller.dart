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

  @override
  void onInit() {
    super.onInit();
    loadSelectedStore();
    loadPromotionImages();
    loadMenuList();
    loadProducts();
  }

  @override
  void onClose() {
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

  // 修改选择菜单的方法，直接从服务器获取对应类型的商品
  void selectMenu(int menuId) {
    selectedMenuId.value = menuId;
    final selectedMenu = menuList.firstWhere((menu) => menu.id == menuId);
    loadProductsByType(selectedMenu.type);
  }
}
