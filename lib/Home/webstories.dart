import 'dart:convert';
import 'package:dainik_media_newsapp/Home/Components/webstorycardview.dart';
import 'package:dainik_media_newsapp/Home/fullarticle.dart';
import 'package:dainik_media_newsapp/Home/Components/Newscardviewhome.dart';
import 'package:dainik_media_newsapp/Home/webstoryopener.dart';
import 'package:dainik_media_newsapp/Loading/postskeleton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class WebStories extends StatefulWidget {
  final String newsapi;
  const WebStories({Key? key, required this.newsapi}) : super(key: key);

  @override
  State<WebStories> createState() => _WebStoriesState();
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

class _WebStoriesState extends State<WebStories> {
//  List<dynamic> posts = [];
  List posts = [];
  final scrollController = ScrollController();
  int page = 1;
  bool isloadingmore = false;
  bool isLoadingInitial = true;
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

                if (post['author_info'] != null) {
                  author = removeHtmlTags(post['author_info']['display_name']);
                }

                return Webstorycard(
                  ontapfacebookshare: () {
                    onFacebookShare(context, post);
                  },
                  ontapwhatsappshare: () {
                    onwhatsappShare(context, post);
                  },
                  ontapshare: () {
                    onShare(context, post);
                  },
                  ontap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            WebStoriesOpener(url: post['link'], title: ''),
                      ),
                    );
                  },
                  date: formattedDate,
                  author: '',
                  title: removeHtmlTags(post['title']['rendered']),
                  subtitle: removeHtmlTags(post['excerpt']['rendered']),
                  imglink: post['story_poster']['url'],
                );
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

  String formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final DateFormat formatter =
        DateFormat('d MMMM y, HH:mm'); // Updated pattern
    return formatter.format(dateTime);
  }
}
