import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ArticleDetailPage extends StatelessWidget {
  final String url;

  const ArticleDetailPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.close,
              size: 24,
              color: Colors.black54,
            ),
          ),
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(url)),
        ),
      ),
    );
  }
}
