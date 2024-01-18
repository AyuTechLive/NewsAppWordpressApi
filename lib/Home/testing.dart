import 'dart:convert';
import 'package:dainik_media_newsapp/Home/fullarticle.dart';
import 'package:dainik_media_newsapp/Home/Components/Newscardviewhome.dart';
import 'package:dainik_media_newsapp/Home/webstoryopener.dart';
import 'package:dainik_media_newsapp/Loading/postskeleton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';

class Testing extends StatefulWidget {
  final String newsapi;
  const Testing({Key? key, required this.newsapi}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

String removeHtmlTags(String htmlString) {
  // Use HtmlUnescape to decode HTML entities and remove HTML tags
  var unescape = HtmlUnescape();
  var decodedString = unescape.convert(htmlString);

  // Remove HTML tags
  decodedString = decodedString.replaceAll(RegExp(r'<[^>]*>'), '');

  // Remove additional HTML entities that are not covered by HtmlUnescape
  // This regex targets decimal and hexadecimal entities
  decodedString = decodedString.replaceAll(RegExp(r'&#\d+;'), '');
  decodedString = decodedString.replaceAll(RegExp(r'&#x[a-fA-F0-9]+;'), '');

  return decodedString;
}

class _TestingState extends State<Testing> {
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<List<dynamic>> fetchPosts() async {
    final response = await http.get(Uri.parse(widget.newsapi));

    if (response.statusCode == 200) {
      final List<dynamic> fetchedPosts = json.decode(response.body);

      fetchedPosts.sort((a, b) {
        DateTime dateA = DateTime.parse(a['date']);
        DateTime dateB = DateTime.parse(b['date']);
        return dateB.compareTo(dateA);
      });

      return fetchedPosts;
    } else {
      return []; // Return an empty list or handle error appropriately
    }
  }

  // ... (other methods and code)

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;

    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: fetchPosts(), // the future function to execute
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the future to complete, show the progress indicator
            return PostSkeleton();
          } else if (snapshot.hasError) {
            // If we run into an error, we can handle it here, maybe show an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Once the data is available, render the ListView
            return ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: width * 0.5,
                  child: Container(
                    width: width * 0.5,
                    height: height * 0.001,
                    color: Colors.grey,
                  ),
                );
              },
              itemCount: snapshot.data!.length,
             itemBuilder: (context, index) {
  final post = snapshot.data![index];
  if (post == null || post.isEmpty) {
    return PostSkeleton();
  }
  String formattedDate = formatDate(post['date_gmt']);
  String author = '';
  
  // Access the sourceUrl of the image within the nested JSON structure
  String imglink = '';
  try {
    List<dynamic> elements = post['story_data']['pages'][0]['elements'];
    for (var element in elements) {
      if (element['type'] == 'image') {
        imglink = element['resource']['sizes']['thumbnail']['sourceUrl'];
        break; // Break the loop once the image link is found
      }
    }
  } catch (e) {
    // Handle the case where the structure does not match or is missing
    print('Error parsing image link: $e');
  }

  if (post['author_info'] != null) {
    author = removeHtmlTags(post['author_info']['display_name']);
  }

  // Check if the imglink is not empty and then use it
  if (imglink.isNotEmpty) {
    return Image.network(imglink);
  } else {
    return Text('No image found');
  }
},
            );
          } else {
            // If the snapshot has no data and no error, show a message
            return Center(child: Text('No posts found'));
          }
        },
      ),
    );
  }

  String formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final DateFormat formatter =
        DateFormat('d MMMM y, HH:mm'); // Updated pattern
    return formatter.format(dateTime);
  }
}
