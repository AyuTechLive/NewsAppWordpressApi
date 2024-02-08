import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  List<Map<String, dynamic>> posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(fetchData.toString())),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://danikmedia.com/wp-json/wp/v2/posts?slug=is-week-ott-par-release-hog-sushmita-sen-ki-arya3-aur-bhumi-pednekar-ki-bhakshak/'));

    if (response.statusCode == 200) {
      return json.decode(response.body)[0];
    } else {
      throw Exception('Failed to load data');
    }
  }
  // Future<List> fetchPost() async {
  //   final response = await http.get(Uri.parse(
  //       'https://danikmedia.com/wp-json/wp/v2/posts?slug=is-week-ott-par-release-hog-sushmita-sen-ki-arya3-aur-bhumi-pednekar-ki-bhakshak/'));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> jsonList = jsonDecode(response.body);
  //     return jsonList;
  //   } else {
  //     return [];
  //     // Consider handling errors by showing a message or retry option
  //   }
  // }
}
