import 'dart:convert';
import 'package:dainik_media_newsapp/Home/fullarticle.dart';
import 'package:dainik_media_newsapp/Home/Components/Newscardviewhome.dart';
import 'package:dainik_media_newsapp/Loading/postskeleton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class DainikMedia2 extends StatefulWidget {
  final String newsapi;
  const DainikMedia2({Key? key, required this.newsapi}) : super(key: key);

  @override
  State<DainikMedia2> createState() => _DainikMedia2State();
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

class _DainikMedia2State extends State<DainikMedia2> {
  // List<dynamic> posts = [];
  // List<dynamic> posts2 = [];
  List posts = [];
  final scrollController = ScrollController();
  int page = 1;
  bool isloadingmore = false;
  bool isLoadingInitial = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrolllistner);
    fetchPost();
  }

  Future<void> fetchPost() async {
    final response = await http
        .get(Uri.parse(widget.newsapi + 'posts?per_page=11&page=$page'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;
      setState(() {
        posts = posts + json;
        isLoadingInitial = false; // Set to false once posts are fetched
      });
    } else {
      // Consider handling errors by showing a message or retry option
      setState(() {
        isLoadingInitial =
            false; // Even on error, we're not loading initially anymore
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    if (isLoadingInitial) {
      return Scaffold(
        body: PostSkeleton(), // Show loading indicator
      );
    }

    return Scaffold(
        body: ListView.separated(
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
      controller: scrollController,
      itemCount: isloadingmore ? posts.length + 1 : posts.length,
      itemBuilder: (context, index) {
        if (index < posts.length) {
          final post = posts[index];
          final title = post['title']['rendered'];
          String formattedDate = formatDate(post['date_gmt']);
          String author = '';

          if (post['author_info'] != null) {
            author = removeHtmlTags(post['author_info']['display_name']);
          }
          if (post == null || post.isEmpty) {
            return PostSkeleton();
          }
          return Newscardview(
              ontap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PostDetailScreen(post: post),
                  ),
                );
              },
              ontapshare: () {
                onShare(context, post);
              },
              date: formattedDate,
              author: author,
              title: removeHtmlTags(post['title']['rendered']),
              subtitle: removeHtmlTags(post['excerpt']['rendered']),
              imglink: post['jetpack_featured_media_url']);
        } else {
          return Padding(
              padding: EdgeInsets.only(top: height * 0.01),
              child: Center(child: CircularProgressIndicator()));
        }
      },
    ));
  }

  String formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('d MMMM y'); // Updated pattern
    return formatter.format(dateTime);
  }

  void onShare(BuildContext context, dynamic post) async {
    final String textToShare =
        '${post['title']['rendered']} Read More On ${post['link']} ';
    await Share.share(textToShare, subject: 'Sharing via Danik Media');
  }

  Future<void> _scrolllistner() async {
    if (isloadingmore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isloadingmore = true;
      });
      page = page + 1;
      await fetchPost();
      setState(() {
        isloadingmore = false;
      });
    } else {}
  }
}
