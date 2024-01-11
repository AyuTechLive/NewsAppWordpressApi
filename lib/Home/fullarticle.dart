import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

class PostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);
  String _parseHtmlString(String htmlString) {
    final RegExp tagRegExp = RegExp(r'<[^>]+>');

    // Remove all HTML tags using RegExp
    String withoutHtml = htmlString.replaceAll(tagRegExp, '');

    // Unescape the HTML entities
    String unescapedHtml = HtmlUnescape().convert(withoutHtml);

    // Trim leading and trailing whitespace and collapse multiple spaces into one
    String trimmedAndCollapsed =
        unescapedHtml.replaceAll(RegExp(r'\s+'), ' ').trim();

    return trimmedAndCollapsed;
  }

  @override
  Widget build(BuildContext context) {
    // Replace this with your actual UI components to display the post details
    return Scaffold(
      appBar: AppBar(
        title: Text(_parseHtmlString(post['title']['rendered'])),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network(post['jetpack_featured_media_url']),
            Padding(
              padding: EdgeInsets.all(8.0), // Add some padding around the text
              child: Text(
                _parseHtmlString(post['content']['rendered']),
                style: TextStyle(
                    height:
                        1.5), // You can adjust line spacing for better readability
              ),
            ),
            // Add more widgets to display other post details as needed
          ],
        ),
      ),
    );
  }
}