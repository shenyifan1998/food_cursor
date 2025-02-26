import 'package:get/get.dart';

class Store {
  final int id;
  final String name;
  final String address;
  final String businessHours;
  final double distance;
  final bool isOpen;
  final bool supportsTakeout;
  final String cityName;
  final String phone;
  final RxBool isFavorite;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.businessHours,
    required this.distance,
    required this.isOpen,
    required this.supportsTakeout,
    required this.cityName,
    required this.phone,
    bool isFavorite = false,
  }) : this.isFavorite = isFavorite.obs;

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      businessHours: json['businessHours'],
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      isOpen: json['isOpen'] ?? false,
      supportsTakeout: json['supportsTakeout'] ?? false,
      cityName: json['cityName'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
