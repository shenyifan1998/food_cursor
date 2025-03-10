class Product {
  final int id;
  final String name;
  final String description;
  final List<String> tags;
  final double originalPrice;
  final double discountPrice;
  final String imageUrl;
  final String menuType;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.tags,
    required this.originalPrice,
    required this.discountPrice,
    required this.imageUrl,
    required this.menuType,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['menuName'] as String,
      description: json['explain'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      menuType: json['menuType'] as String,
    );
  }
}
