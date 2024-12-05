import 'package:dhafs_app/app/data/models/models_cake.dart';

// import 'package:dhafs_app/app/modules/controllers/auth_controllers.dart';
// import 'package:dhafs_app/app/modules/controllers/micHandle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/services/services_gps.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                "LOGO",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Get.toNamed('/profile');
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: Get.find<HomeController>().textController,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(controller.isListening.value
                        ? Icons.mic
                        : Icons.mic_none),
                    onPressed: () {
                      controller.startListening();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: () async {
            controller.fetchCake();
          },
          child: Obx(() {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.cakes.isEmpty) {
              return Center(child: Text('No Cake found'));
            }
            return Column(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hot Items",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.cakes.length,
                          itemBuilder: (context, index) {
                            final article = controller.cakes[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: HotItemCard(article: article),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: controller.cakes.length,
                    itemBuilder: (context, index) {
                      return ItemCard(result: controller.cakes[index]);
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(context);
        },
        backgroundColor: Colors.grey,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddItemDialog(BuildContext context) async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController description = TextEditingController();
    final TextEditingController harga = TextEditingController();
    final TextEditingController keterangan = TextEditingController();

    final HomeController homeController = HomeController();
    final ServicesGps services_gps = ServicesGps();
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
          title: Text("Add Cake Item"),
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

                controller.CreateData(
                    imageUrl, title, _harga, Desc, _keterangan, coordinate);

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

class HotItemCard extends StatelessWidget {
  final Result article;

  const HotItemCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(
              article.image,
              fit: BoxFit.cover,
              height: 80,
              width: 150,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              article.title.length > 10
                  ? article.title.substring(0, 10)
                  : article.title,
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Result result;

  const ItemCard({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Image.network(
                result.image,
                fit: BoxFit.cover,
                scale: 1.0,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF383838),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0),
              ),
            ),
            child: TextButton(
              onPressed: () {
                Get.toNamed('/detail', arguments: result);
              },
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF383838),
                padding: EdgeInsets.zero,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  result.title.length > 10
                      ? result.title.substring(0, 10)
                      : result.title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
