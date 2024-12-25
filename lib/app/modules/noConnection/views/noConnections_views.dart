import 'package:dhafs_app/app/data/services/services_gps.dart';
import 'package:dhafs_app/app/modules/home/controllers/home_controller.dart';
import 'package:dhafs_app/app/modules/noConnection/controllers/noConnection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoconnectionsViews extends StatelessWidget {
  const NoconnectionsViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                padding: const EdgeInsets.all(20),
                child: const Icon(
                  Icons.wifi_off,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'No Internet Connection',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Tambahkan logika untuk menambahkan data offline di sini
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Offline Mode'),
                      content: const Text('Do you want to add data offline?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showAddItemDialogOffline(context);
                            // Logika untuk menambahkan data offline
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Add Data Offline',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddItemDialogOffline(BuildContext context) async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController description = TextEditingController();
    final TextEditingController harga = TextEditingController();
    final TextEditingController keterangan = TextEditingController();

    final HomeController homeController = HomeController();
    final ServicesGps services_gps = ServicesGps();
    final NoconnectionController noConnection = NoconnectionController();
    await services_gps.getCurrentLocation();
    String coordinate = '';
    String lokasi = '';

    coordinate = services_gps.currentPosition!.latitude.toString() +
        ',' +
        services_gps.currentPosition!.longitude.toString();

    lokasi = await homeController.fetchLocationName(coordinate) as String;
    print(coordinate);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Cake Item Offline Mode"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Cake Title"),
                ),
                TextField(
                  controller: imageController,
                  decoration: InputDecoration(labelText: "Image URL"),
                ),
                TextField(
                  controller: description,
                  decoration: InputDecoration(labelText: "Deskripsi"),
                ),
                TextField(
                  controller: harga,
                  decoration: InputDecoration(labelText: "Harga"),
                ),
                TextField(
                  controller: keterangan,
                  decoration: InputDecoration(labelText: "Keterangan"),
                ),
                const SizedBox(height: 15.0),
                Text(
                  'Coordinate : ' + coordinate,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 15.0),
                Text('Lokasi : ' + lokasi)
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String imageUrl = imageController.text;
                String Desc = description.text;
                String _harga = harga.text;
                String _keterangan = keterangan.text;

                noConnection.saveDataOffline(
                    title, imageUrl, Desc, _harga, _keterangan, coordinate);

                Get.back();
              },
              child: Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
