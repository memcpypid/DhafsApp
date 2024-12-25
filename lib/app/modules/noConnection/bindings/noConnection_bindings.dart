import 'package:get/get.dart';
import '../controllers/noConnection_controller.dart';

class NoconnectionBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<NoconnectionController>(NoconnectionController(), permanent: true);
  }
}
