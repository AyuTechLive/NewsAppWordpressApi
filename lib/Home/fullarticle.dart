import 'package:dainik_media_newsapp/Components/exractslugs.dart';
import 'package:dainik_media_newsapp/Components/inapplinks.dart';
import 'package:dainik_media_newsapp/Home/dainikmedia.dart';
import 'package:dainik_media_newsapp/Testing/testinglinks.dart';
import 'package:dainik_media_newsapp/Utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;
  final String newsapi;

  PostDetailScreen({Key? key, required this.post, required this.newsapi})
      : super(key: key);

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
    if (newsapi.contains('https://danikmedia.com/')) {
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

  final Set<String> processedInstagramUrls = Set<String>();
  final Set<String> processedTwitterUrls = Set<String>();
  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();

    return Scaffold(
      appBar: AppBar(
          //title: Text(unescape.convert(post['title']['rendered'])),
          ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0), // Consistent padding for the entire body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (post['jetpack_featured_media_url'] != null)
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
                removeHtmlTags(post['title']['rendered']),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
              ),
            SizedBox(
              height: 10,
            ),
            // Text(removeHtmlTags(
            //     '')),

            HtmlWidget(extractContentBeforeJoinUs(post['content']['rendered']),
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
                final posts = await fetchPost11(slug, newsapi);

                if (posts.isNotEmpty) {
                  final post11 = posts[0];

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailScreen(
                        post: post11,
                        newsapi: newsapi,
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
