class LeftSideMenu {
  final int id;
  final String type;
  final String typeName;
  final int orderNum;
  final bool isSelected;

  LeftSideMenu({
    required this.id,
    required this.type,
    required this.typeName,
    required this.orderNum,
    this.isSelected = false,
  });

  factory LeftSideMenu.fromJson(Map<String, dynamic> json) {
    return LeftSideMenu(
      id: json['id'] as int,
      type: json['type'] as String,
      typeName: json['typeName'] as String,
      orderNum: json['orderNum'] as int,
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }
}
