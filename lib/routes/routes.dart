import 'package:delivery_man_app/controllers/MyOrders/myorders_bindings.dart';
import 'package:delivery_man_app/controllers/Orders/orders_bindings.dart';
import 'package:delivery_man_app/controllers/QR/qr_binding.dart';
import 'package:delivery_man_app/views/DrawerPages/scan_qr_page.dart';
import 'package:delivery_man_app/views/MyOrders/my_orders_page.dart';
import 'package:get/get.dart';
import '../controllers/Auth/auth_binding.dart';

import '../views/Auth/login_page.dart';
import '../views/OrderDetails/orders_details_page.dart';
import '../views/Orders/orders_page.dart';
import '../views/Welcome/splash_page.dart';

class Routes {
  static const splashPage = '/splashPage';
  static const loginPage = '/loginPage';
  static const mainPage = '/mainPage';
  static const orderssPage = '/orderssPage';
  static const ordersDetailsPage = '/ordersDetailsPage';
  static const myOrderssPage = '/myOrderssPage';
  static const scanQRPage = '/scanQRPage';
}

class AppRoutes {
  static final routes = [
    GetPage(
      name: Routes.splashPage,
      page: () => const SplashPage(),
    ),
    /////////////////////////
    GetPage(
      name: Routes.loginPage,
      page: () => LoginPage(),
      transition: Transition.fade,
      binding: AuthBinding(),
      transitionDuration: const Duration(milliseconds: 500),
    ),

    /// app route //////////////////////////////
    GetPage(
      name: Routes.orderssPage,
      page: () => OrdersPage(),
      binding: OrdersBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 0),
    ),
    ///////
    GetPage(
      name: Routes.ordersDetailsPage,
      page: () => OrdersDetailsPage(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    ///////
    GetPage(
      name: Routes.myOrderssPage,
      page: () => MyOrdersPage(),
      binding: MyOrdersBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    ///////
    GetPage(
      name: Routes.scanQRPage,
      page: () => ScanQRPage(),
      transition: Transition.fade,
      binding: QRBinding(),
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}
