import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashService {
  static const String _baseUrl = 'https://api.unsplash.com';
  static const String _accessKey =
      '6NnGGoQ-i6we9pOXdEq5FvXpZgvwYgwENFIH5LxEywI'; // 请替换为您的 access key

  /// 获取随机美食图片
  /// 返回值为包含图片URL的 [UnsplashPhoto] 对象
  /// 如果发生错误，将抛出异常
  Future<UnsplashPhoto> getRandomFoodPhoto() async {
    final Uri url =
        Uri.parse('$_baseUrl/photos/random?query=food&orientation=portrait');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Client-ID $_accessKey'},
    );

    if (response.statusCode == 200) {
      return UnsplashPhoto.fromJson(json.decode(response.body));
    } else {
      throw Exception('获取图片失败: ${response.statusCode}');
    }
  }
}

class UnsplashPhoto {
  final String id;
  final String regularUrl; // 720p图片URL

  UnsplashPhoto({
    required this.id,
    required this.regularUrl,
  });

  factory UnsplashPhoto.fromJson(Map<String, dynamic> json) {
    return UnsplashPhoto(
      id: json['id'] as String,
      regularUrl: json['urls']['regular'] as String,
    );
  }
}
