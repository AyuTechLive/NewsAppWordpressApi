import 'package:dainik_media_newsapp/Home/dainikmedia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

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
            HtmlWidget(
              post['content']['rendered'],
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
              },
              customWidgetBuilder: (element) {
                if (element.localName == 'img') {
                  final src = element.attributes['src'];
                  return src != null ? Image.network(src) : Placeholder();
                }
                return null;
              },
              onTapUrl: (url) {
                // Implement a proper URL handling logic
                // For example, you could use url_launcher to launch the URL
                _launchURL(url.toString());
                return true;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Could not launch $urlString';
    }
  }
}
