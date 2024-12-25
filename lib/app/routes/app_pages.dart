import 'package:dhafs_app/app/modules/image/bindings/image_binding.dart';
import 'package:dhafs_app/app/modules/image/views/image_view.dart';
import 'package:dhafs_app/app/modules/music/bindings/music_binding.dart';
import 'package:dhafs_app/app/modules/music/views/music_view.dart';
import 'package:dhafs_app/app/modules/noConnection/bindings/noConnection_bindings.dart';
import 'package:dhafs_app/app/modules/noConnection/views/noConnections_views.dart';
import 'package:dhafs_app/app/modules/profile/bindings/profile_binding.dart';
import 'package:dhafs_app/app/modules/profile/views/profile_view.dart';
import 'package:dhafs_app/app/modules/register/bindings/register_binding.dart';
import 'package:dhafs_app/app/modules/register/views/register_view.dart';
import 'package:get/get.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/detail/bindings/detail_binding.dart';
import '../modules/detail/views/detail_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/bindings/home_binding.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const INITIAL = Routes.LOGIN;
  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL,
      page: () => DetailView(),
      binding: DetailBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.IMAGE,
      page: () => ImageView(),
      binding: ImageBinding(),
    ),
    GetPage(
      name: _Paths.MUSIC,
      page: () => MusicPlayerView(),
      binding: MusicBinding(),
    ),
    GetPage(
      name: _Paths.NOCONNECTION,
      page: () => NoconnectionsViews(),
      binding: NoconnectionBindings(),
    ),
  ];
}
