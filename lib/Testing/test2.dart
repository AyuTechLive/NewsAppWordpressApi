import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Test2 extends StatefulWidget {
  const Test2({
    Key? key,
  }) : super(key: key);
  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http
        .get(Uri.parse('https://danikmedia.com/wp-json/wp/v2/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonCategories = json.decode(response.body);
      categories = jsonCategories
          .map((category) => Category.fromJson(category))
          .toList();

      setState(() {});
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WordPress Categories'),
      ),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              print(categories[index].id);
            },
            title: Text(categories[index].name),
            subtitle: Text(categories[index].description),
          );
        },
      ),
    );
  }
}

class Category {
  final int id;
  final int count;
  final String description;
  final String link;
  final String name;
  final String slug;
  final String taxonomy;
  final int parent;

  Category({
    required this.id,
    required this.count,
    required this.description,
    required this.link,
    required this.name,
    required this.slug,
    required this.taxonomy,
    required this.parent,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      count: int.parse(json['count'].toString()), // Convert to int
      description: json['description'] ?? '',
      link: json['link'],
      name: json['name'],
      slug: json['slug'],
      taxonomy: json['taxonomy'],
      parent: int.parse(json['parent'].toString()), // Convert to int
    );
  }
}
