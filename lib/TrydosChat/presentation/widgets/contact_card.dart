import 'package:delivery_man_app/TrydosChat/data/models/my_contacts_response_model.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
import 'package:delivery_man_app/TrydosChat/helper/helper_functions.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_bloc.dart';
import 'package:delivery_man_app/TrydosChat/presentation/utils/responsive_padding.dart';
import 'package:delivery_man_app/TrydosChat/presentation/widgets/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../data/models/my_chats_response_model.dart';
import '../pages/single_page_chat.dart';
import 'chat_widgets/no_image_widget.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.index, required this.contact});
  final int index;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    FlutterError.onError = (FlutterErrorDetails error) {
      GetIt.I<PrefsRepository>().saveRequestsData(
          null, null, null, null, null, null, null,
          error: error.toString());
      debugPrint(error.toString());
    };
    final String receiverName, fullReceiverName;
    if (contact.name == null) {
      receiverName = 'uk'.tr;
      fullReceiverName = contact.mobilePhone ?? 'UnKnown User';
    } else {
      receiverName = HelperFunctions.getTheFirstTwoLettersOfName(contact.name!);
      fullReceiverName = contact.name!;
    }

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        height: index == 0 ? 0 : 0.4,
        color: const Color(0xffC8C7CC),
        margin: HWEdgeInsetsDirectional.only(start: 94),
      ),
      SizedBox(
          height: 100.h,
          width: 1.sw,
          child: GestureDetector(
              onTap: () {
                if (contact.contactUserId == null) {
                  return;
                }
                Chat? chat;
                User? receiver;
                List<Chat> chats = List.of(GetIt.I<ChatBloc>().state.chats);
                debugPrint(chats.toString());
                chats.addAll(GetIt.I<ChatBloc>().state.pinnedChats);
                chat = chats.firstWhere((element) => element.channelMembers!
                    .any((element) => element.userId == contact.contactUserId));
                final preferences = GetIt.I<PrefsRepository>();

                receiver = chat.channelMembers
                    ?.firstWhere(
                      (element) => element.userId != preferences.myChatId,
                      orElse: () => ChannelMember(
                          userId: contact.contactUserId,
                          user: User(
                              id: contact.contactUserId, name: contact.name)),
                    )
                    .user;
                ////////////////////////
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SinglePageChat(
                      chatId: chat!.id!.toString(),
                      fullReceiverName: receiverName,
                      receiverName: fullReceiverName,
                      receiverPhone: receiver?.mobilePhone ?? 'No Number',
                      senderName: HelperFunctions.getTheFirstTwoLettersOfName(
                          GetIt.I<PrefsRepository>().myChatName!),
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    padding: HWEdgeInsets.only(left: 15.w, right: 10.w),
                    color: Colors.white,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // receiver?.photoPath != null
                          //     ? BlocBuilder<AppBloc, AppState>(
                          //   builder: (context, state) {
                          //     return Container(
                          //       decoration: BoxDecoration(
                          //         borderRadius:
                          //         BorderRadius.circular(12.0),
                          //       ),
                          //       child: MyCachedNetworkImage(
                          //           imageUrl: ChatUrls.baseUrl +
                          //               receiver?.photoPath,
                          //           imageFit: BoxFit.cover,
                          //           height: 80.h,
                          //           width: 60.w),
                          //     );
                          //   },
                          // )
                          NoImageWidget(
                              width: 60.w,
                              height: 80.h,
                              textStyle: const TextStyle(
                                color: Color(0xff6638FF),
                                letterSpacing: 0.18,
                                height: 1.33,
                                fontWeight: FontWeight.bold,
                              ),
                              //     context.textTheme.bodyMedium?.br.copyWith(
                              //   color: const Color(0xff6638FF),
                              //   letterSpacing: 0.18,
                              //   height: 1.33,
                              // ),
                              name: receiverName),
                          18.horizontalSpace,
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                    child: Row(
                                  children: [
                                    MyTextWidget(
                                      fullReceiverName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xff505050),
                                        letterSpacing: 0.18,
                                        height: 1.33,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      // context.textTheme.bodyMedium?.rr.copyWith(
                                      //     height: 1.33,
                                      //     color: const Color(0xff505050)),
                                    ),
                                    const Spacer(),
                                    if (contact.contactUserId == null) ...{
                                      MyTextWidget(
                                        'invite'.tr,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xff388cff),
                                          letterSpacing: 0.18,
                                          height: 1.33,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        // context.textTheme.bodyMedium?.rr
                                        //     .copyWith(
                                        //         height: 1.33,
                                        //         color: const Color(0xff388cff)),
                                      ),
                                      25.horizontalSpace,
                                    }
                                  ],
                                ))
                              ],
                            ),
                          ),
                        ]),
                  )
                ],
              )))
    ]);
  }
}
