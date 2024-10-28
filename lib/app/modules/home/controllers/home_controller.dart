import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../data/services/service_cake.dart';
import '../../../data/models/models_cake.dart';

class HomeController extends GetxController {
  final HttpController httpController = HttpController();

  @override
  void onInit() {
    super.onInit();
    fetchCake();
  }

  void fetchCake() async {
    await httpController.fetchCake();
  }

  WebViewController webViewController(String uri) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(uri));
  }

  List<Result> get cakes => httpController.result;
  bool get isLoading => httpController.isLoading.value;
}
