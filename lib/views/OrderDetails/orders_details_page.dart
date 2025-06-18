import 'package:delivery_man_app/TrydosChat/data/models/my_chats_response_model.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_bloc.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_event.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_state.dart';
import 'package:delivery_man_app/TrydosChat/presentation/pages/single_page_chat.dart';
import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/handling_errors.dart/handling_errors.dart';
import 'package:delivery_man_app/shared/widgets/app_dialogs.dart';
import 'package:delivery_man_app/shared/widgets/snackbar_widgets.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../shared/constants/order_statuses.dart';
import '../../shared/widgets/custom_app_bar.dart';
import 'order_details_with_status_buttons.dart';

class OrdersDetailsPage extends StatefulWidget {
  const OrdersDetailsPage({super.key});

  @override
  State<OrdersDetailsPage> createState() => _OrdersDetailsPageState();
}

class _OrdersDetailsPageState extends State<OrdersDetailsPage> {
  final OrdersController ordersController = Get.find<OrdersController>();

  @override
  void initState() {
    super.initState();
    //////////////
    getAllData();
  }

  void getAllData() async {
    print(
        "DDDDDDDDDDDDDDDDDDDDDDDDDSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSssss---------${GlobalFunctions.getIsFromNotifiForNewOrder()}");

    if (GlobalFunctions.getIsFromNotifiForNewOrder()) {
      String token = GlobalFunctions.getToken();
      //////////////////////////////////////////////////////////
      print(
          "DDDDDDDDDDDDDDDDDDDDDDDDDSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSssss");
      await ordersController.getOrderDetailsData(
        token: token,
        orderId: int.parse(GlobalFunctions.getOrderId() ?? '-1'),
        isForMyOrder: false,
      );
      print(
          "DDDDDDDDDDDDDDDDDDDDDDDDDSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSssss++++");

      GetIt.I<ChatBloc>().add(GetOrderRecipientIdEvent(
          originalUserId: GlobalFunctions.getUserId().toString(),
          orderId: ordersController.myOrderIdInMarket.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    String status;
    if (GlobalFunctions.getIsFromNotifiForNewOrder()) {
      status = (GetIt.I<PrefsRepository>().myOrderIdForChat != "" &&
              GetIt.I<PrefsRepository>().myOrderIdForChat != null)
          ? OrderStatuses.outForDelivery
          : OrderStatuses.inDeliveryCenter;
    } else {
      if (ordersController.previousRoute == Routes.myOrdersPage) {
        status = ordersController.myOrderStatus;
      } else {
        status = ordersController.orderStatus;
      }
    }
    return SafeArea(
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          stopRecordingCondition(context);
          ///////////////////////////////////////
          debugPrint('previousRoute is ${ordersController.previousRoute}');
          ///////////////////////////////////////
          if (ordersController.isAssignUnAssignOrderCircleShown ||
              ordersController.isChangeOrderStatusCircleShown ||
              ordersController.isGetOrderDetailsCircleShown) {
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: buildAppBar(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          body: GetBuilder<OrdersController>(
            id: 'all_order_details_page',
            builder: (_) {
              return HandlingFailures.pageErrorHandling(
                isCircleShown: ordersController.isGetOrderDetailsCircleShown,
                isNoInternetConnection:
                    GlobalFunctions.getIsFromNotifiForNewOrder()
                        ? ordersController.isGetOrderDetailsNoInternetShown
                        : false,
                onTapTry: () {
                  getAllData();
                },
                page: OrderDetailsWithStatusButtons(),
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return customAppBar(
      title: 'Order Details'.tr,
      button: GetBuilder<OrdersController>(
        builder: (_) {
          if (ordersController.isRecording) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextWidget(
                    text: 'Recording . . .'.tr,
                    color: AppColors.blackDark,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    maxline: 1),
                const SizedBox(
                  width: 5,
                ),
                const Icon(Icons.settings_voice_outlined),
              ],
            );
          } else {
            if (ordersController.previousRoute == Routes.myOrdersPage ||
                GlobalFunctions.getIsFromNotifiForNewOrder()) {
              String status = "";
              if (GlobalFunctions.getIsFromNotifiForNewOrder() &&
                  (GetIt.I<PrefsRepository>().myOrderIdForChat != "" &&
                      GetIt.I<PrefsRepository>().myOrderIdForChat != null)) {
                ordersController.myOrderStatus = OrderStatuses.outForDelivery;
              }
              status = ordersController.myOrderStatus;

              return
                  // (status == OrderStatuses.shipped) ||
                  (status == OrderStatuses.outForDelivery)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BlocListener<ChatBloc, ChatState>(
                              listenWhen: (previous, current) =>
                                  previous.getOrderRecipientIdStatus !=
                                  current.getOrderRecipientIdStatus,
                              listener: (context, state) {
                                if (state.getOrderRecipientIdStatus ==
                                    GetOrderRecipientIdStatus.success) {
                                  String receiverName = "recipient";
                                  String fullReceiverName = "recipient";
                                  String? recipientUserId =
                                      state.recipientUserId;
                                  if (recipientUserId == null) {
                                    return;
                                  }
                                  Chat? chat;
                                  User? receiver;
                                  List<Chat> chats =
                                      List.of(GetIt.I<ChatBloc>().state.chats);
                                  debugPrint(chats.toString());
                                  chats.addAll(
                                      GetIt.I<ChatBloc>().state.pinnedChats);
                                  chat = chats.firstWhere((element) =>
                                      element.channelMembers!.any((element) {
                                        return element.userId.toString() ==
                                            recipientUserId;
                                      }));
                                  final preferences =
                                      GetIt.I<PrefsRepository>();
                                  receiver = chat.channelMembers
                                      ?.firstWhere(
                                        (element) =>
                                            element.userId !=
                                            preferences.myChatId,
                                        orElse: () => ChannelMember(
                                            userId:
                                                int.tryParse(recipientUserId),
                                            user: User(
                                                id: int.tryParse(
                                                    recipientUserId),
                                                name: receiverName)),
                                      )
                                      .user;
                                  print(
                                      "DDDDDDDDDDDDDDDEEEEEEEEEEEEEEEEEEEEEEEEE${chat.id ?? ""}");
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SinglePageChat(
                                        orderId: ordersController
                                            .myOrderIdInMarket
                                            .toString(),
                                        chatId: chat?.id ?? "",
                                        receiverName: "CU",
                                        receiverPhone: "",
                                        fullReceiverName: "Customer",
                                        senderName: "Ali",
                                      ),
                                    ),
                                  );
                                }
                                // TODO: implement listener
                              },
                              child: BlocBuilder<ChatBloc, ChatState>(
                                buildWhen: (previous, current) =>
                                    previous.getOrderRecipientIdStatus !=
                                    current.getOrderRecipientIdStatus,
                                builder: (context, state) {
                                  if (state.getOrderRecipientIdStatus ==
                                          GetOrderRecipientIdStatus.loading &&
                                      GlobalFunctions.getChatToken()
                                          .isNotEmpty &&
                                      GlobalFunctions.getChatToken()
                                          .isNotEmpty) {
                                    return const SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return InkWell(
                                    onTap: () {
                                      if (GlobalFunctions.getMobilePhone()
                                          .isNotEmpty) {
                                        if ((GetIt.I<PrefsRepository>()
                                                    .chatToken
                                                    ?.length ??
                                                0) >
                                            7) {
                                          GetIt.I<ChatBloc>().add(
                                              GetOrderRecipientIdEvent(
                                                  originalUserId:
                                                      GlobalFunctions
                                                              .getUserId()
                                                          .toString(),
                                                  orderId: ordersController
                                                      .myOrderIdInMarket
                                                      .toString()));

                                          // Get.toNamed(Routes.chatPage);
                                        } else {
                                          Get.toNamed(
                                              Routes.otpVerificationPage);
                                        }
                                      } else {
                                        SnackBarWidgets.showSuccessSnackBar(
                                            'Please enter the phone number',
                                            '');
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 30,
                                      height: 40,
                                      child: const Icon(Icons.chat),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : Container();
            } else {
              return Container();
            }
          }
        },
      ),
    );
  }

  void stopRecordingCondition(BuildContext context) {
    if ((ordersController.previousRoute == Routes.myOrdersPage) &&
        (ordersController.myOrderStatus == OrderStatuses.outForDelivery) &&
        (!ordersController.isStartDeliveryButton &&
            !GlobalFunctions.getIsFromNotifiForNewOrder())) {
      AppDialogs.showConfirmationDialog(
        context: context,
        title: 'Are you sure to stop recording and leave this page ?'.tr,
        onConfirm: () async {
          Get.back();
          Get.close(1);
          ordersController.changeDeliveringButton(true);
          await ordersController.stopRecording();
          ordersController.returnedProductsList.clear();
          ordersController.audioPath = '';
        },
      );
    }
  }
}
