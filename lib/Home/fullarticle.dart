import 'dart:convert';

import 'package:dainik_media_newsapp/Categories/categories.dart';
import 'package:dainik_media_newsapp/Colors.dart';
import 'package:dainik_media_newsapp/Components/exractslugs.dart';
import 'package:dainik_media_newsapp/Components/inapplinks.dart';
import 'package:dainik_media_newsapp/Home/Components/Newscardviewhome.dart';
import 'package:dainik_media_newsapp/Home/Components/categorycardview.dart';
import 'package:dainik_media_newsapp/Home/dainikmedia.dart';
import 'package:dainik_media_newsapp/Home/dainikmedianew.dart';
import 'package:dainik_media_newsapp/Testing/testinglinks.dart';
import 'package:dainik_media_newsapp/Utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

List<Category> categories = [];

class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;
  final String newsapi;

  PostDetailScreen({Key? key, required this.post, required this.newsapi})
      : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  TextStyle _textStyle(double fontSize) {
    // You can also use Theme.of(context) to access the current theme data
    return TextStyle(
      fontSize: fontSize,
      height: 1.5, // Line height for better readability
    );
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

  String extractContentBeforeJoinUs(String htmlString) {
    if (widget.newsapi.contains('https://danikmedia.com/')) {
      var unescape = HtmlUnescape();
      var decodedString = unescape.convert(htmlString);

      // Skip content within <p lang="en" dir="ltr"> tags
      decodedString = decodedString.replaceAllMapped(
        RegExp(r'<p\s+lang="en"\s+dir="ltr">(.*?)<\/p>', dotAll: true),
        (match) {
          // Replace content within <p lang="en" dir="ltr"> tags with an empty string
          return '';
        },
      );

      // Remove content after </p>&mdash;
      decodedString = decodedString.replaceAllMapped(
        RegExp(r'</p>&mdash;(.*?)<', dotAll: true),
        (match) {
          // Replace content after </p>&mdash; with an empty string
          return '<'; // Maintain the tag structure
        },
      );

      // Remove content like "Senator Penny Wong (@SenatorWong)"
      decodedString = decodedString.replaceAllMapped(
        RegExp(r'<p>(.*?Senator\s+[A-Za-z]+\s+@\S+.*?)<\/p>', dotAll: true),
        (match) {
          // Replace content matching the pattern with an empty string
          return '';
        },
      );

      // Remove content like </p>&mdash; Senator Penny Wong (@SenatorWong)
      decodedString = decodedString.replaceAllMapped(
        RegExp(r'</p>&mdash;(.*?)<', dotAll: true),
        (match) {
          // Replace content matching the pattern with an empty string
          return '<'; // Maintain the tag structure
        },
      );

      // Remove Table of Contents content
      decodedString = decodedString.replaceAllMapped(
        RegExp(
            r'Table of Contents<\/p>\n<span class=\"ez-toc-title-toggle\"><a[^>]*>.*?<\/a><\/span><\/div>\n<nav>(.*?)<\/nav>',
            dotAll: true),
        (match) {
          // Replace content matching the pattern with an empty string
          return '';
        },
      );

      if (decodedString.contains('" id=\"JOIN_US\"')) {
        int joinUsIndex = decodedString.indexOf('" id=\"JOIN_US\"');

        // Extract content before "Join Us"
        String extractedContent = decodedString.substring(0, joinUsIndex);

        return extractedContent;
      }
      if (decodedString.contains('gb-icon')) {
        int joinUsIndex = decodedString.indexOf('gb-icon');

        // Extract content before "Join Us"
        String extractedContent = decodedString.substring(0, joinUsIndex);

        return extractedContent;
      } else {
        return decodedString;
      }
    }
    // Use HtmlUnescape to decode HTML entities and remove HTML tags
    else {
      return htmlString;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategories();
  }

  final Set<String> processedInstagramUrls = Set<String>();

  final Set<String> processedTwitterUrls = Set<String>();

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    final unescape = HtmlUnescape();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: Colors.white,

        //title: Text(unescape.convert(post['title']['rendered'])),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.backgroundColor,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/icons/whatsapp.png'),
                        ),
                        title: Text('Join Danik Media on WhatsApp'),
                        onTap: () {
                          launchUrl(Uri.parse(
                              'https://www.whatsapp.com/channel/0029VaBzL0yKrWR57pL7w315'));

                          // Handle Option 1
                        },
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/icons/telegram.png'),
                        ),
                        title: Text('Join Danik Media on Telegram'),
                        onTap: () {
                          // Handle Option 2
                          launchUrl(Uri.parse('https://t.me/danikmedia'));
                        },
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/icons/facebook.png'),
                        ),
                        title: Text('Join Danik Media on Facebook'),
                        onTap: () {
                          launchUrl(
                              Uri.parse('https://www.facebook.com/danikmedia'));
                        },
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/icons/instagram.png'),
                        ),
                        title: Text('Join Danik Media on Instagram'),
                        onTap: () {
                          launchUrl(Uri.parse(
                              'https://www.instagram.com/danikmedia/'));
                          // Handle Option 2
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Image.asset(
            'assets/icons/megaphone.png',
            scale: 17,
            color: Colors.white,
          )),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0), // Consistent padding for the entire body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (widget.post['jetpack_featured_media_url'] != null)
              // Padding(
              //   padding: const EdgeInsets.only(
              //       bottom: 12.0), // Spacing after the image
              //   child: Image.network(
              //     post['jetpack_featured_media_url'],
              //     // Placeholder widget to show while the image is loading
              //     loadingBuilder: (BuildContext context, Widget child,
              //         ImageChunkEvent? loadingProgress) {
              //       if (loadingProgress == null) return child;
              //       return Center(
              //         child: CircularProgressIndicator(
              //           value: loadingProgress.expectedTotalBytes != null
              //               ? loadingProgress.cumulativeBytesLoaded /
              //                   loadingProgress.expectedTotalBytes!
              //               : null,
              //         ),
              //       );
              //     },
              //   ),
              // ),
              Text(
                removeHtmlTags(widget.post['title']['rendered']),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
              ),
            SizedBox(
              height: 10,
            ),
            // Text(removeHtmlTags(
            //     '')),

            HtmlWidget(
                extractContentBeforeJoinUs(widget.post['content']['rendered']),
                textStyle: _textStyle(16), // Apply the base text style
                customStylesBuilder: (element) {
              switch (element.localName) {
                case 'h1':
                  return {'font-size': '24px', 'margin': '12px 0'};
                case 'h2':
                  return {'font-size': '20px', 'margin': '10px 0'};
                case 'p':
                  return {'line-height': '1.5'};
              }
              return null;
            }, customWidgetBuilder: (element) {
              if (element.attributes['href'] != null) {
                final src = element.attributes['href']!;
                if (src.contains("instagram.com")) {
                  if (src.contains("instagram.com/p/") ||
                      src.contains("instagram.com/tv/")) {
                    if (!processedInstagramUrls.contains(src)) {
                      processedInstagramUrls.add(src);
                      print('Instagram URL: $src');
                      return _buildWebView(src);
                    }
                  }
                } else if (src.contains("twitter.com")) {
                  if (src.contains("t.co") || src.contains("twitter.com/")) {
                    if (!processedTwitterUrls.contains(src)) {
                      processedTwitterUrls.add(src);
                      print('Twitter URL: $src');
                      return _buildWebView(src);
                    }
                  }
                }
                return null;
              }
            }, onTapUrl: (url) async {
              if (url.contains('https://danikmedia.com/') ||
                  url.contains('https://graamsetu.com/') ||
                  url.contains('https://bhatnerpost.com/')) {
                MySnackbar.show(context, 'Loading Please Wait....');
                final slug = extractSlugFromUrl(url);
                final posts = await fetchPost11(slug, widget.newsapi);

                if (posts.isNotEmpty) {
                  final post11 = posts[0];

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailScreen(
                        post: post11,
                        newsapi: widget.newsapi,
                      ),
                    ),
                  );
                } else {
                  MySnackbar.show(context, 'Error loading post');
                }

                return true;
              } else {
                _launchURL(url);
                return true;
              }
            }),
            SizedBox(
              height: 25,
            ),
            Text(
              'Categories:-',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            SizedBox(
              height: height * 0.075,
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 20,
                  );
                },
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Categorycardview(
                    title: categories[index].name,
                    subtitle: 'subtitle',
                    imglink:
                        'https://danikmedia.com/wp-content/uploads/2024/02/06.jpeg',
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Categoriesop(
                                title: categories[index].name,
                                newsapi:
                                    '${widget.newsapi}posts?categories=${categories[index].id}&'),
                          ));
                    },
                    author: 'author',
                    date: 'date',
                  );
                  // ListTile(
                  //   onTap: () {
                  //     print(categories[index].id);
                  //   },
                  //   title: Text(categories[index].name),
                  //   subtitle: Text(categories[index].description),
                  // );
                },
              ),
            ),
            SizedBox(height: height * 0.08)
          ],
        ),
      ),
    );
  }

  Widget _buildWebView(String url) {
    print('WebView URL: $url');
    return Container(
      height: 500,
      width: 400,
      child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(url)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true,
              supportZoom:
                  false, // Consider changing this to support zoom if necessary
              preferredContentMode: UserPreferredContentMode
                  .MOBILE, // Ensures mobile-optimized content
            ),
          )),
    );
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('${widget.newsapi}categories'));

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

  String extractInstagramUrl(String htmlString) {
    final match =
        RegExp(r'data-instgrm-permalink="(.*?)"').firstMatch(htmlString);
    return match?.group(1) ?? '';
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $urlString';
    }
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
