import 'package:audioplayers/audioplayers.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/assets_provider.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/build_context.dart';
import 'package:delivery_man_app/TrydosChat/config/theme/my_color_scheme.dart';
import 'package:delivery_man_app/TrydosChat/config/theme/typography.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_bloc.dart';
import 'package:delivery_man_app/TrydosChat/presentation/widgets/my_cached_network_image.dart';
import 'package:delivery_man_app/TrydosChat/presentation/widgets/my_text_widget.dart';
import 'package:delivery_man_app/TrydosChat/presentation/widgets/trydos_loader.dart';
import 'package:delivery_man_app/calls/presentation/bloc/calls_bloc.dart';
import 'package:delivery_man_app/calls/presentation/widgets/no_image_widget.dart';
import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import '../widgets/call_status_widget.dart';


// ignore: must_be_immutable
class AnswerCall extends StatefulWidget {
  String channelName;
  String messageId;
  String callerName;
  String? callerPhoto;

  AnswerCall(
      {required this.callerPhoto,
      required this.callerName,
      required this.channelName,
      required this.messageId,
      super.key});

  @override
  State<AnswerCall> createState() => _AnswerCallState();
}

class _AnswerCallState extends State<AnswerCall> {
  var player = AudioPlayer();

  @override
  void dispose() {
    GetIt.I<CallsBloc>().add(InitResponseRejectVideoCallEvent());

    Vibration.cancel();
    player.stop();
    // TODO: implement dispose
    super.dispose();
  }

  late ChatBloc chatBloc;

  @override
  void initState() {
    PagesMonitor.addPageToList(page: 'AnswerCall');
    chatBloc = BlocProvider.of<ChatBloc>(context);
    if (GetIt.I<CallsBloc>().state.makeCallStatus == MakeCallStatus.endCall) {
      Navigator.of(context).pop();
      debugPrint('poppp');
    } else {
      Vibration.vibrate(repeat: 0, pattern: [1000, 1000, 1000, 1000]);
      player.setReleaseMode(ReleaseMode.loop);
      player.play(AssetSource(
        'audio/Whatsapp_Tone.mp3',
      ));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterError.onError = (FlutterErrorDetails error) {
      //LastPagesTracker.sendErrorToBlocAndLog(error);
      FlutterError.dumpErrorToConsole(error);
    };

    // er.oGoRoutf(context).p
    return Scaffold(
      backgroundColor: ColorScheme.fromSwatch().black,
      body: BlocConsumer<CallsBloc, CallsState>(
        builder: (context, state) {
          return Column(
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  140.verticalSpace,
                  Center(
                      child: widget.callerPhoto != null
                          ? Container(
                              height: 200,
                              width: 200.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border:
                                    Border.all(color: const Color(0xff388cff)),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          // ignore: deprecated_member_use
                                          ColorScheme.fromSwatch().white.withOpacity(0.35),
                                      offset: const Offset(0, 10),
                                      blurRadius: 30,
                                      spreadRadius: 10),
                                ],
                              ),
                              child: MyCachedNetworkImage(
                                  imageUrl: (widget.callerPhoto
                                              .toString()
                                              .contains("cloudinary")
                                          ? ""
                                          : "${dotenv.env['Images_Url']}") +
                                      widget.callerPhoto!,
                                  imageFit: BoxFit.cover,
                                  progressIndicatorBuilderWidget:
                                      TrydosLoader(),
                                  height: 80.h,
                                  width: 60.w),
                            )
                          : NoImageWidget(
                              width: 120.w,
                              height: 180.h,
                              textStyle: TextStyle(),
                              name: widget.callerName)),
                  15.verticalSpace,
                  MyTextWidget(
                    widget.callerName,
                    style: TextStyle(
                      color: ColorScheme.fromSwatch().white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  80.verticalSpace,
                  CallStatusWidget(
                    text: 'calling'.tr,
                    iconUrl: AppAssets.callingSvg,
                    textColor: ColorScheme.fromSwatch().grey200,
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      width: 100.w,
                      height: 100.h,
                      child: TextButton(
                        onPressed: () async {
                          await Vibration.cancel();
                          await player.stop();
                          await [Permission.camera, Permission.microphone]
                              .request()
                              .then((value) {
                            GetIt.I<CallsBloc>().add(AnswerVideoCallEvent(
                                chatId: widget.channelName,
                                messageId: widget.messageId));
                          });
                        },
                        child: MyTextWidget(
                          'answer'.tr,
                          style: const TextStyle(color: Colors.green),
                        ),
                      )),
                  TextButton(
                      onPressed: () async {
                        GetIt.I<CallsBloc>().add(RejectVideoCallEvent(
                          messageId: widget.messageId,
                          duration: 0,
                        ));
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          width: 100.w,
                          height: 100.h,
                          child: Center(
                              child: MyTextWidget(
                            'reject'.tr,
                            style: const TextStyle(color: Colors.red),
                          ))))
                ],
              )
            ],
          );
        },
        // listenWhen: (previous, current) =>
        //     previous.createVideoCallStatus != current.createVideoCallStatus,
        listener: (context, state) {
          debugPrint("zczczxc");
          if (state.makeCallStatus == MakeCallStatus.endCall) {
            debugPrint("adasd");
            Navigator.of(context).pop();
          }

          // else  if (state.rejectVideoCallStatus == RejectVideoCallStatus.success)
          //    Navigator.pop(context);
          //  else if (state.createVideoCallStatus == CreateVideoCallStatus.success) {
          //    debugPrint("anmzxch");
          //    Navigator.of(context).push(MaterialPageRoute(
          //      builder: (context) =>
          //          AgoraWebView(type: "video", channelId: widget.channelName, auth_token: state.agoraToken!, uId: GetIt.I<PrefsRepository>().myChatId!.toString(),),
          //
          //    ));
          //  }
        },
      ),
    );
  }
}
