import 'package:delivery_man_app/controllers/OTP/otp_binding.dart';
import 'package:delivery_man_app/controllers/Orders/orders_bindings.dart';
import 'package:delivery_man_app/controllers/QR/qr_binding.dart';
import 'package:delivery_man_app/views/Auth/choose_otp_method.dart';
import 'package:delivery_man_app/views/Auth/insert_number_page.dart';
import 'package:delivery_man_app/views/Auth/otp_verification_page.dart';
import 'package:delivery_man_app/views/Chat/chat_page.dart' show ChatPage;
import 'package:delivery_man_app/views/DrawerPages/info_for_developer/info_for_developer_page.dart';
import 'package:delivery_man_app/views/DrawerPages/info_for_developer/more_info_page.dart';
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

  static const insertNumberPage = '/insertNumberPage';
  static const chooseOtpMethod = '/chooseOtpMethod';

  static const orderssPage = '/orderssPage';
  static const ordersDetailsPage = '/ordersDetailsPage';
  static const myOrdersPage = '/myOrderssPage';
  static const scanQRPage = '/scanQRPage';
  static const infoForDeveloper = '/infoForDeveloper';
  static const moreInfoPage = '/moreInfoPage';
  static const chatPage = '/chatPage';
  static const otpVerificationPage = '/OtpVerificationPage';
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
      binding: AuthBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    /////////////////////////
    GetPage(
      name: Routes.insertNumberPage,
      page: () => InsertNumberPage(),
      binding: AuthBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    /////////////////////////
    GetPage(
      name: Routes.chooseOtpMethod,
      page: () => ChooseOtpMethod(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    /// app route //////////////////////////////
    GetPage(
      name: Routes.orderssPage,
      page: () => OrdersPage(),
      bindings: [
        OrdersBinding(),
        AuthBinding(),
      ],
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 0),
    ),
    ///////
    GetPage(
      name: Routes.myOrdersPage,
      page: () => MyOrdersPage(),
      bindings: [
        OrdersBinding(),
        AuthBinding(),
      ],
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 0),
    ),
    ///////
    GetPage(
      name: Routes.ordersDetailsPage,
      page: () => const OrdersDetailsPage(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: Routes.scanQRPage,
      page: () => ScanQRPage(),
      transition: Transition.fade,
      binding: QRBinding(),
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: Routes.infoForDeveloper,
      page: () => InfoForDeveloperPage(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: Routes.moreInfoPage,
      page: () => MoreInfoPage(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: Routes.chatPage,
      page: () => const ChatPage(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: Routes.otpVerificationPage,
      page: () => const OtpVerificationPage(),
      transition: Transition.cupertino,
      binding: OtpBinding(),
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}
