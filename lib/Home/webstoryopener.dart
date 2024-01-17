import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebStoriesOpener extends StatefulWidget {
  final String url;
  final String title;

  const WebStoriesOpener({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  State<WebStoriesOpener> createState() => _WebStoriesOpenerState();
}

class _WebStoriesOpenerState extends State<WebStoriesOpener> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 2),
        child: InAppWebView(
          
          initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
                // Set any initial options if necessary.
                ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            webViewController = controller;
            // You can use the controller to interact with the WebView.
          },
          onLoadStart: (InAppWebViewController controller, Uri? url) {
            // Indicates that the URL has started loading.
          },
          onLoadStop: (InAppWebViewController controller, Uri? url) {
            // Indicates that the URL has finished loading.
          },
          onProgressChanged: (InAppWebViewController controller, int progress) {
            // You can use this callback to get the loading progress.
          },
        ),
      ),
    );
  }
}
