import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/models_cake.dart';

class DbController extends GetxController {
  RxList<Result> result = RxList<Result>([]);
  RxBool isLoading = false.obs;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> getCakes() async {
    try {
      isLoading.value = true;
      List<Map<String, dynamic>> jsonData = [];
      await db.collection("cakees").get().then((event) {
        for (var doc in event.docs) {
          print(doc);
          Map<String, dynamic> data = doc.data(); // as Map<String, dynamic>;
          data['id'] = doc.id;
          jsonData.add(data);
        }
      });
      final cakeResultJson = {
        "results": jsonData,
        "offset": 0,
        "number": jsonData.length,
        "totalResults": jsonData.length
      };
      final cakeResult = Welcome.fromJson(cakeResultJson);
      result.value = cakeResult.results;
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCake(Result cake) async {
    try {
      isLoading.value = true;
      DocumentReference docRef =
          await db.collection("cakees").add(cake.toJson());
      print('Added cake with ID: ${docRef.id}');
      await getCakes();
    } catch (e) {
      print('Error adding cake: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCake(String id, Result updatedCake) async {
    try {
      isLoading.value = true;
      await db.collection("cakees").doc(id).update(updatedCake.toJson());
      print('Updated cake ID: $id');
      await getCakes();
    } catch (e) {
      print('Error updating cake: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCake(String id) async {
    try {
      isLoading.value = true;
      db.collection("cakees").doc(id).delete();
      print('Deleted cake  ID: $id');
      await getCakes();
    } catch (e) {
      print('Error deleting cake: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
