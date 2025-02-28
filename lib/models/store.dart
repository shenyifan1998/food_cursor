import 'package:get/get.dart';

class Store {
  final int id;
  final String name;
  final String address;
  final String? phone; // 可空
  final String businessHours;
  final int status;
  final bool supportsTakeout;
  final String cityCode;
  final String cityName;
  final RxBool _isFavorite;

  Store({
    required this.id,
    required this.name,
    required this.address,
    this.phone, // 可空
    required this.businessHours,
    required this.status,
    required this.supportsTakeout,
    required this.cityCode,
    required this.cityName,
    bool isFavorite = false,
  }) : _isFavorite = isFavorite.obs;

  bool get isFavorite => _isFavorite.value;
  set isFavorite(bool value) => _isFavorite.value = value;

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '未知门店',
      address: (json['address'] as String?) ?? '地址未提供',
      phone: json['phone'] as String?,
      businessHours: (json['businessHours'] as String?) ?? '09:00-21:00',
      // 处理JSON中可能不存在的字段
      status: (json['status'] as int?) ?? 0, // 示例JSON无此字段
      supportsTakeout: (json['supportsTakeout'] as bool?) ?? false,
      cityCode: (json['cityCode'] as String?) ?? '000000', // 示例JSON无此字段
      cityName: (json['cityName'] as String?) ?? '未知城市',
      isFavorite: (json['isFavorite'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'businessHours': businessHours,
      'status': status,
      'supportsTakeout': supportsTakeout,
      'cityCode': cityCode,
      'cityName': cityName,
      'isFavorite': isFavorite,
    };
  }
}
