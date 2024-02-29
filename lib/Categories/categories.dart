import 'dart:convert';
import 'package:dainik_media_newsapp/Colors.dart';
import 'package:dainik_media_newsapp/Home/fullarticle.dart';
import 'package:dainik_media_newsapp/Home/Components/Newscardviewhome.dart';
import 'package:dainik_media_newsapp/Loading/postskeleton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Categoriesop extends StatefulWidget {
  final String newsapi;
  final String title;
  const Categoriesop({Key? key, required this.newsapi, required this.title})
      : super(key: key);

  @override
  State<Categoriesop> createState() => _CategoriesopState();
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

class _CategoriesopState extends State<Categoriesop> {
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
    if (widget.newsapi.contains('categories')) {
      print('hiiiiiiiiiiiiiiiiiiiiiiiiiii');
      final response =
          await http.get(Uri.parse(widget.newsapi + '&page=$page'));
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
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    if (isLoadingInitial) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(widget.title),
          backgroundColor: AppColors.backgroundColor,
        ),
        body: PostSkeleton(), // Show loading indicator
      );
    }

    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(widget.title),
          backgroundColor: AppColors.backgroundColor,
        ),
        body: Column(children: [
          Expanded(
            child: ListView.separated(
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
                    author =
                        removeHtmlTags(post['author_info']['display_name']);
                  }
                  if (post == null || post.isEmpty) {
                    return PostSkeleton();
                  }
                  return Newscardview(
                      ontapfacebookshare: () {
                        onFacebookShare(context, post);
                      },
                      ontap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PostDetailScreen(
                              post: post,
                              newsapi: widget.newsapi,
                            ),
                          ),
                        );
                      },
                      ontapwhatsappshare: () {
                        onwhatsappShare(context, post);
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
            ),
          ),
        ]));
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

  void onwhatsappShare(BuildContext context, dynamic post) async {
    final String textToShare =
        '${post['title']['rendered']} Read More On ${post['link']} ';
    // Encode the text to share
    final String urlEncodedText = Uri.encodeComponent(textToShare);

    // Create the WhatsApp share URL
    final String whatsappUrl = "whatsapp://send?text=$urlEncodedText";

    // Check if WhatsApp can be opened

    // Launch WhatsApp
    launchUrl(Uri.parse(whatsappUrl));

    // If WhatsApp is not installed or the URL scheme does not work,
    // you can either prompt the user or use the default share dialog as a fallback

    // You can use Share.share as a fallback or handle it differently
    //await Share.share(textToShare, subject: 'Sharing via Dainik Media');
  }

  void onFacebookShare(BuildContext context, dynamic post) async {
    final String textToShare =
        '${post['title']['rendered']} Read More On ${post['link']} ';
    // URL to the Facebook share dialog
    final String facebookUrl =
        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(post['link'])}&quote=${Uri.encodeComponent(textToShare)}';

    // Check if the Facebook share URL can be launched

    // Launch the Facebook share dialog
    launchUrl(Uri.parse(facebookUrl));
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $urlString';
    }
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
