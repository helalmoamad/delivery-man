import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import '../models/AssignToVehicle/unassign_to_vehicle_model.dart';
import '../models/Orders/list_order_model.dart';
import '../services/networking/orders_api_service.dart';
import '../shared/errors/exceptions.dart';
import '../shared/errors/failures.dart';
import '../shared/network_info/network_info.dart';

class OrdersRepository {
  final OrdersApiService ordersApiService;
  final NetworkInfo networkInfo;

  OrdersRepository({required this.ordersApiService, required this.networkInfo});

  Future<Either<Failure, ListOrderModel>> getListOrderData(
      {required String token,
      required String status,
      required int offset}) async {
    if (await networkInfo.isConnected) {
      try {
        final orderDataResponse = await ordersApiService.getListOrderDataApi(
            token: token, status: status, offset: offset);
        return Right(orderDataResponse);
      } on ServerException {
        // final orderDataResponse = ListOrderModel(
        //     data: ListOrderDataModel(
        //   currentPage: 1,
        //   total: 1,
        //   data: [
        //     OrderModel(
        //         id: 1,
        //         journeyId: 1,
        //         assignToUserId: 3,
        //         customerId: 4,
        //         paymentStatus: 'paymentStatus',
        //         orderStatusId: 2,
        //         paymentMethod: 'paymentMethod',
        //         transactionRef: 'transactionRef',
        //         orderAmount: 200,
        //         orderAmountFormatted: 'orderAmountFormatted',
        //         shippingAddressId: 'shippingAddressId',
        //         orderGroupId: 'orderGroupId',
        //         verificationCode: 'verificationCode',
        //         sellerId: 'sellerId',
        //         details: [
        //           Detail(
        //               id: 1,
        //               qty: 1,
        //               tax: 2,
        //               price: 'price',
        //               odooId: 1,
        //               variant: 'variant',
        //               discount: 'discount',
        //               orderId: 3,
        //               productId: 2,
        //               discountType: 'discountType',
        //               odooOrderId: 1,
        //               paymentStatus: 'paymentStatus',
        //               refundRequest: 2,
        //               deliveryStatus: 'deliveryStatus',
        //               isOdooProduct: 1,
        //               productDetails: OrderProductDetails(
        //                   id: 1,
        //                   name: 'name',
        //                   slug: 'slug',
        //                   price: 'price',
        //                   images: [''],
        //                   rating: Rating(totalRating: 1, overallRating: 2),
        //                   details: 'details',
        //                   inStock: false,
        //                   thumbnail: 'thumbnail',
        //                   shareLink: 'shareLink',
        //                   offerPrice: 'offerPrice',
        //                   isFavourite: false,
        //                   priceFormatted: 'priceFormatted',
        //                   offerPriceFormatted: 'offerPriceFormatted'),
        //               isStockDecreased: 1,
        //               shippingMethodId: 'shippingMethodId',
        //               priceAfterDiscount: 'priceAfterDiscount',
        //               refundRequestStatus: 'refundRequestStatus'),
        //         ],
        //         shippingAddress: 'shippingAddress',
        //         shippingAddressData: ShippingAddressData(
        //             id: 1,
        //             zip: 'zip',
        //             city: 'city',
        //             cost: 'cost',
        //             email: 'email',
        //             phone: 'phone',
        //             state: 'state',
        //             address: 'address',
        //             country: 'country',
        //             duration: 'duration',
        //             latitude: 'latitude',
        //             longitude: 'longitude',
        //             createdAt: null,
        //             isBilling: 1,
        //             isDefault: 1,
        //             updatedAt: null,
        //             customerId: 1,
        //             addressType: 'addressType',
        //             contactPersonName: 'contactPersonName'),
        //         billingAddress: 'billingAddress',
        //         billingAddressData: 'billingAddressData',
        //         orderStatus: 'orderStatus'),
        //   ],
        // ));
        // return Right(orderDataResponse);
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, ListOrderModel>> getMyOrdersData(
      {required String token,
      required String status,
      required int offset}) async {
    if (await networkInfo.isConnected) {
      try {
        final orderDataResponse = await ordersApiService.getMyOrdersDataApi(
            token: token, status: status, offset: offset);
        return Right(orderDataResponse);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, List<dynamic>>> getOrderStatusData({
    required String token,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final orderStatusDataResponse =
            await ordersApiService.getOrderStatusDataApi(token);
        return Right(orderStatusDataResponse);
      } on ServerException {
        // final orderStatusDataResponse = [
        //   'pending',
        //   'processing',
        //   'ready_to_shipping'
        // ];
        // return Right(orderStatusDataResponse);
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, UnAssignToVehicleModel>> unAssignToVehicle(
      {required String token, required int vehicleId}) async {
    if (await networkInfo.isConnected) {
      try {
        final dataResponse = await ordersApiService.postUnAssignToVehicleApi(
            token: token, vehicleId: vehicleId);
        return Right(dataResponse);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, AssignOrderToMeDataModel>> assignOrderToMe(
      {required String token, required int orderId}) async {
    if (await networkInfo.isConnected) {
      try {
        final dataResponse = await ordersApiService.postAssignOrderToMeApi(
            token: token, orderId: orderId);
        return Right(dataResponse);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, Unit>> changeStatus({
    required String token,
    required String status,
    required int orderId,
    required double? amount,
    required List<ProductModel>? returnedProducts,
    required String? file,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await ordersApiService.postChangeStatusApi(
          token: token,
          orderId: orderId,
          file: file,
          status: status,
          returnedProducts: returnedProducts,
          amount: amount,
        );
        return const Right(unit);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
