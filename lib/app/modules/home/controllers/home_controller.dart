import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../data/services/service_cake.dart';
import '../../../data/models/models_cake.dart';

class HomeController extends GetxController {
  final DbController dbontroller = DbController();

  @override
  void onInit() {
    super.onInit();
    fetchCake();
  }

  void fetchCake() async {
    await dbontroller.getCakes();
  }

  void CreateData(String url, String Title, String Harga, String Deskripsi,
      String Keterangan) {
    Result newCake = Result(
        title: Title,
        image: url,
        id: '',
        imageType: ImageType.JPG,
        hargaProduk: Harga,
        deskripsiProduk: Deskripsi,
        keteranganProduk: Keterangan);
    dbontroller.addCake(newCake);
  }

  WebViewController webViewController(String uri) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(uri));
  }

  List<Result> get cakes => dbontroller.result;
  bool get isLoading => dbontroller.isLoading.value;
}
