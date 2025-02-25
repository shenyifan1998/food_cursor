import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/city.dart';
import '../services/city_service.dart';
import 'package:lpinyin/lpinyin.dart';

class CitySelectController extends GetxController {
  final CityService _cityService = CityService();
  final isLoading = true.obs;
  final currentCity = Rx<City>(City(
    code: '130200',
    name: '唐山市',
    provinceCode: '130000',
  ));
  final hotCities = <City>[].obs;
  final cityGroups = <CityGroup>[].obs;
  final scrollController = ScrollController();
  final letterPositions = <String, double>{};
  final searchController = TextEditingController();
  final RxList<City> searchResults = <City>[].obs;
  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCities();
    searchController.addListener(_onSearchChanged);
    // 监听滚动，记录每个字母的位置
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateLetterPositions();
    });
  }

  void _calculateLetterPositions() {
    double position = 0;

    // 定位城市高度
    letterPositions['定位'] = 0;
    position += 36; // 标题高度
    position += 50; // 定位城市高度

    // 热门城市高度
    letterPositions['热门'] = position;
    position += 36; // 标题高度
    position += ((hotCities.length + 3) ~/ 4) * 44; // 热门城市行高（每行44像素）
    position += 32; // 上下padding

    // 字母分组城市高度
    for (var group in cityGroups) {
      letterPositions[group.letter] = position;
      position += 36; // 字母标题高度
      position += group.cities.length * 44; // 每个城市项44像素高
    }
  }

  Future<void> loadCities() async {
    try {
      isLoading.value = true;
      final response = await _cityService.getCityGroups();

      // 设置热门城市（限制8个）
      hotCities.value = response.hotCities.take(8).toList();

      // 按字母分组其他城市（排除 I、O、U、V）
      final Map<String, List<City>> groups = {};
      for (var city in response.allCities) {
        final letter = _getFirstLetter(city.name);
        if (letter != '#' && !['I', 'O', 'U', 'V'].contains(letter)) {
          groups.putIfAbsent(letter, () => []).add(city);
        }
      }

      // 排序并设置城市分组
      final sortedGroups = groups.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      cityGroups.value = sortedGroups
          .map((e) => CityGroup(letter: e.key, cities: e.value))
          .toList();

      // 计算字母位置
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _calculateLetterPositions();
      });
    } catch (e) {
      Get.snackbar('错误', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectCity(City city) {
    Get.back(result: city);
  }

  void scrollToLetter(String letter) {
    if (letterPositions.containsKey(letter)) {
      scrollController.animateTo(
        letterPositions[letter]!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSearchChanged() {
    final keyword = searchController.text.trim();
    if (keyword.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
      return;
    }

    // 确保输入至少一个完整的汉字或字母才开始搜索
    if (keyword.length >= 1) {
      isSearching.value = true;
      searchResults.value = _searchCities(keyword);
    }
  }

  List<City> _searchCities(String keyword) {
    final List<City> results = [];
    final String lowercaseKeyword = keyword.toLowerCase();

    // 获取所有城市列表
    List<City> allCities = [];
    allCities.addAll(hotCities);
    for (var group in cityGroups) {
      allCities.addAll(group.cities);
    }

    // 按名称和拼音搜索
    for (var city in allCities) {
      // 匹配城市名称
      if (city.name.contains(keyword)) {
        results.add(city);
        continue;
      }

      // 匹配拼音全拼
      String pinyin = PinyinHelper.getPinyinE(
        city.name,
        defPinyin: '',
        format: PinyinFormat.WITHOUT_TONE,
      ).toLowerCase();
      if (pinyin.contains(lowercaseKeyword)) {
        results.add(city);
        continue;
      }

      // 匹配拼音首字母
      String pinyinInitials =
          PinyinHelper.getShortPinyin(city.name).toLowerCase();
      if (pinyinInitials.contains(lowercaseKeyword)) {
        results.add(city);
      }
    }

    return results;
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  String _getFirstLetter(String name) {
    // 获取完整拼音
    String pinyin = PinyinHelper.getPinyinE(name,
        defPinyin: name, format: PinyinFormat.WITHOUT_TONE);

    // 如果转换失败（返回原字符），则返回 '#'
    if (pinyin == name) {
      return '#';
    }

    // 获取首字母并转大写
    String firstLetter = pinyin[0].toUpperCase();

    // 如果不是 A-Z，返回 '#'
    if (!RegExp(r'[A-Z]').hasMatch(firstLetter)) {
      return '#';
    }

    return firstLetter;
  }
}
