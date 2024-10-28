import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../models/models_cake.dart';

class HttpController extends GetxController {
  RxList<Result> result = RxList<Result>([]);
  RxBool isLoading = false.obs;

  Future<void> fetchCake() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/complexSearch?query=cake&number=15&offset=0&apiKey=fed2835278a6400e92b88b3c20c2def3'));

      if (response.statusCode == 200) {
        final jsonData = response.body;
        final cakeResult = Welcome.fromJson(json.decode(jsonData));
        result.value = cakeResult.results;
        // print(cakeResult);
      } else {
        print('Return with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erorr: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
