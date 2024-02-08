import 'dart:convert';

import 'package:http/http.dart' as http;

List<Map<String, dynamic>> posts = [];

Future<List<Map<String, dynamic>>> fetchPost11(
    String slug, String newsapi) async {
  final response = await http.get(Uri.parse(newsapi + 'posts?slug=$slug/'));
  if (response.statusCode == 200) {
    final jsonList = jsonDecode(response.body) as List;
    posts = List<Map<String, dynamic>>.from(jsonList);
    return posts;
  } else {
    return [];
  }
}
