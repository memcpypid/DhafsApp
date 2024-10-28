import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import '../../../data/models/models_cake.dart';
import '../controllers/home_controller.dart';

// ignore: must_be_immutable
class ArticleDetailWebView extends GetView<HomeController> {
  // final Result cake;
  final parameter;
  const ArticleDetailWebView(
      {super.key,

      /// required this.cake,
      required this.parameter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("WebView"),
        ),
        body: WebViewWidget(
          controller: controller.webViewController(
              "https://www.google.com/search?q=kue%20${Uri.encodeComponent(parameter)}"),
        ));
  }
}
