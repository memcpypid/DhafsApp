import 'package:dhafs_app/app/data/models/models_cake.dart';
import 'package:dhafs_app/app/data/services/service_cake.dart';
import 'package:dhafs_app/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  DetailView({super.key});

  Future<void> _refreshData() async {
    final DbController dbController = DbController();
    await dbController.getCakes();
  }

  @override
  Widget build(BuildContext context) {
    final Result result = Get.arguments as Result;
    final DbController dbController = DbController();
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24.0,
                ),
                onPressed: () async {
                  await dbController.getCakes();
                  Get.off(HomeView());
                },
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () => Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25.0),
                    image: DecorationImage(
                      image: NetworkImage(result.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: controller.pickedImage != null
                      ? const Icon(
                          Icons.add_a_photo,
                          size: 48,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 25.0),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF383838),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  result.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                "Deskripsi Produk : " + result.deskripsiProduk,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              const Divider(),
              Text(
                'Harga Produk : ' + result.hargaProduk,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15.0),
              const Divider(),
              Text(
                "Keterangan Produk : " + result.keteranganProduk,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15.0),
              const Divider(),
              Obx(
                () => Text(
                  "Lokasi : " + controller.locationName.value,
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF383838),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const SizedBox(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Buy Now",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Icon(
                        Icons.shopping_cart,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.title.value = result.title;
                      controller.image.value = result.image;
                      controller.deskripsiProduk.value = result.deskripsiProduk;
                      controller.hargaProduk.value = result.hargaProduk;
                      controller.keteranganProduk.value =
                          result.keteranganProduk;

                      Get.defaultDialog(
                        title: "Edit Data",
                        content: Column(
                          children: [
                            TextField(
                              controller: TextEditingController(
                                  text: controller.image.value),
                              decoration:
                                  const InputDecoration(labelText: "URL"),
                              onChanged: (value) =>
                                  controller.image.value = value,
                            ),
                            TextField(
                              controller: TextEditingController(
                                  text: controller.title.value),
                              decoration:
                                  const InputDecoration(labelText: "Title"),
                              onChanged: (value) =>
                                  controller.title.value = value,
                            ),
                            TextField(
                              controller: TextEditingController(
                                  text: controller.deskripsiProduk.value),
                              decoration: const InputDecoration(
                                  labelText: "Deskripsi Produk"),
                              onChanged: (value) =>
                                  controller.deskripsiProduk.value = value,
                            ),
                            TextField(
                              controller: TextEditingController(
                                  text: controller.hargaProduk.value),
                              decoration: const InputDecoration(
                                  labelText: "Harga Produk"),
                              onChanged: (value) =>
                                  controller.hargaProduk.value = value,
                            ),
                            TextField(
                              controller: TextEditingController(
                                  text: controller.keteranganProduk.value),
                              decoration: const InputDecoration(
                                  labelText: "Keterangan Produk"),
                              onChanged: (value) =>
                                  controller.keteranganProduk.value = value,
                            ),
                          ],
                        ),
                        textConfirm: "Save",
                        textCancel: "Cancel",
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          controller.updateData(result.id.toString());
                          Get.back(result: true);
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: "Konfirmasi",
                        middleText:
                            "Apakah Anda yakin ingin menghapus data ini?",
                        onConfirm: () {
                          controller.DeleteData(result.id.toString());
                          Get.back();
                        },
                        onCancel: () => Get.back(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
