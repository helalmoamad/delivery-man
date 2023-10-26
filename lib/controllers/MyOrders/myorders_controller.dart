import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:get/get.dart';

class MyOrdersController extends GetxController {
  bool isGetMyOrdersNoInternetConnection = false;
  bool isGetMyOrdersCircleShown = false;

  late ListOrderModel myOrdersData;

  // ///////////////////////////
  void showGetMyOrdersCircleIndicator() {
    isGetMyOrdersCircleShown = true;
    update();
  }

  void hideGetMyOrdersCircleIndicator() {
    isGetMyOrdersCircleShown = false;
    update();
  }

  void showGetMyOrdersNoInternetPage() {
    isGetMyOrdersNoInternetConnection = true;
    update();
  }

  void hideGetMyOrdersNoInternetPage() {
    isGetMyOrdersNoInternetConnection = false;
    update();
  }

  ///////////////////////////////////
//   Future<void> getMyOrdersData({
//     required String token,
//     required String status,
//     required int offset,
//   }) async {
//     showGetMyOrdersCircleIndicator();
//     paginationOffset = 2;
//     noMoreItems = false;
//     final failureOrGetOrdersData = await getListOrderDataProvider.call(
//         token: token, status: status, offset: offset);
//     failureOrGetOrdersData.fold((failure) {
//       HandlingErrors.networkErrorrHandling(
//           failure: failure,
//           hideCircleIndicator: hideGetMyOrdersCircleIndicator,
//           showNoInternetPage: showGetMyOrdersNoInternetPage);
//     }, (getOrdersData) {
//       myOrdersData = getOrdersData;
//       hideGetMyOrdersCircleIndicator();
//       hideGetMyOrdersNoInternetPage();
//     });
//   }

// ///////////////////////////////////
//   Future<void> getMyOrdersWithPaginationData({
//     required String token,
//     required String status,
//   }) async {
//     if (noMoreItems) {
//       debugPrint('No More Items');
//     } else {
//       final failureOrGetOrdersData = await getListOrderDataProvider.call(
//           token: token, status: status, offset: paginationOffset);
//       failureOrGetOrdersData.fold((failure) {
//         HandlingErrors.networkErrorrHandling(
//             failure: failure,
//             hideCircleIndicator: () {},
//             showNoInternetPage: () {});
//       }, (getOrdersData) {
//         if (getOrdersData.data!.orders!.isEmpty) {
//           noMoreItems = true;
//           debugPrint('No More Items');
//         } else {
//           paginationOffset++;
//           myOrdersData.data!.total = getOrdersData.data!.total;
//           myOrdersData.data!.limit = getOrdersData.data!.limit;
//           myOrdersData.data!.offset = getOrdersData.data!.offset;
//           myOrdersData.data!.orders!.addAll(getOrdersData.data!.orders!);
//         }
//         update();
//       });
//     }
//   }
}
