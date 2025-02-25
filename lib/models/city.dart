class City {
  final String code;
  final String name;
  final String provinceCode;

  City({
    required this.code,
    required this.name,
    required this.provinceCode,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      code: json['code'],
      name: json['name'],
      provinceCode: json['provinceCode'],
    );
  }
}

class CityGroup {
  final String letter;
  final List<City> cities;

  CityGroup({
    required this.letter,
    required this.cities,
  });
}
