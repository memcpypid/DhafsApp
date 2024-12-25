import '../modules/noConnection/bindings/noConnection_bindings.dart';

class DependencyInjection {
  static void init() {
    NoconnectionBindings().dependencies();
  }
}
