import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebView extends StatefulWidget {
  final String webUrl;
  ArticleWebView({this.webUrl});
  @override
  _ArticleWebViewState createState() => _ArticleWebViewState();
}

class _ArticleWebViewState extends State<ArticleWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: <Widget>[
          Text(
            "News",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey[400], fontSize: 23),
          ),
          Text(
            "Today",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[400],
                fontSize: 23),
          ),
        ],
      )),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: WebView(
            initialUrl: widget.webUrl,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          )),
    );
  }
}
