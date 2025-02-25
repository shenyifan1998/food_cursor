import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/city_select_controller.dart';
import '../models/city.dart';

class CitySelectPage extends StatelessWidget {
  final controller = Get.put(CitySelectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择城市'),
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
                hintText: '城市中文名或拼音',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF999999)),
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
          // 搜索结果或城市列表
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.isSearching.value) {
                return ListView.builder(
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    return _buildCityItem(controller.searchResults[index]);
                  },
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      controller: controller.scrollController,
                      slivers: [
                        // 1. 定位城市
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('定位'),
                              _buildLocationCity(),
                            ],
                          ),
                        ),
                        // 2. 热门城市
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('热门城市'),
                              _buildHotCities(),
                            ],
                          ),
                        ),
                        // 3. 按字母分组的城市列表
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final group = controller.cityGroups[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle(group.letter),
                                  ...group.cities
                                      .map((city) => _buildCityItem(city)),
                                ],
                              );
                            },
                            childCount: controller.cityGroups.length,
                          ),
                        ),
                        // 底部填充
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 24),
                        ),
                      ],
                    ),
                  ),
                  _buildLetterBar(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      color: const Color(0xFFF5F5F5),
      width: double.infinity,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF666666),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLocationCity() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.blue, size: 16),
          const SizedBox(width: 8),
          Obx(() => Text(
                controller.currentCity.value.name,
                style: const TextStyle(fontSize: 14),
              )),
        ],
      ),
    );
  }

  Widget _buildHotCities() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.5,
        ),
        itemCount: controller.hotCities.length,
        itemBuilder: (context, index) =>
            _buildHotCityItem(controller.hotCities[index]),
      ),
    );
  }

  Widget _buildHotCityItem(City city) {
    return InkWell(
      onTap: () => controller.selectCity(city),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          city.name,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
          ),
        ),
      ),
    );
  }

  Widget _buildCityItem(City city) {
    return InkWell(
      onTap: () => controller.selectCity(city),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          city.name,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterBar() {
    const validLetters = [
      '定位',
      '热门',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'J',
      'K',
      'L',
      'M',
      'N',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'W',
      'X',
      'Y',
      'Z'
    ];

    return Container(
      width: 28,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        itemCount: validLetters.length,
        itemBuilder: (context, index) {
          final letter = validLetters[index];
          final isSpecial = letter == '定位' || letter == '热门';

          return GestureDetector(
            onTap: () => controller.scrollToLetter(letter),
            child: Container(
              height: 20,
              alignment: Alignment.center,
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: isSpecial ? 10 : 12,
                  color: isSpecial ? const Color(0xFF666666) : Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
