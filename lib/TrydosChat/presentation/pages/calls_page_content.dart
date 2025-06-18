import 'package:delivery_man_app/TrydosChat/chat_utils/theme_state.dart';
import 'package:delivery_man_app/TrydosChat/config/theme/my_color_scheme.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_bloc.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_event.dart';
import 'package:delivery_man_app/TrydosChat/presentation/widgets/sliver_list_seprated.dart';
import 'package:delivery_man_app/TrydosChat/presentation/widgets/trydos_loader.dart';
import 'package:delivery_man_app/calls/presentation/bloc/calls_bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../calls/presentation/widgets/calls_card.dart';

class CallsPageContent extends StatefulWidget {
  const CallsPageContent({Key? key}) : super(key: key);

  @override
  State<CallsPageContent> createState() => _CallsPageContentState();
}

class _CallsPageContentState extends ThemeState<CallsPageContent> {
  late CallsBloc callsBloc;
  late ChatBloc chatBloc;
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    callsBloc = BlocProvider.of<CallsBloc>(context);
    callsBloc.add(ResetMissedCallEvent());
    callsBloc.add(GetMyCallsEvent());
    /* calls.Data data = calls.Data();
    data.copyWith(
      messageStatus: List.empty(),
      createdAt: DateTime.now(),
      receiverUserId: 12222,
      channelId: "1111",
    );*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FlutterError.onError = (FlutterErrorDetails error) {
      chatBloc.add(SendErrorChatToServerEvent(
          error: error.toString(), lastPage: "Calls_Page_Content"));
      GetIt.I<PrefsRepository>().saveRequestsData(
          null, null, null, null, null, null, null,
          error: error.toString());
    };

    return BlocBuilder<CallsBloc, CallsState>(
      buildWhen: (previous, current) {
        return previous.callRegister != current.callRegister;
      },
      builder: (context, state) {
        if (state.callRegister == null ||
            state.getMyCallsStatus != GetMyCallsStatus.success) {
          return SliverToBoxAdapter(
              child: SizedBox(
            height: 1.sh - 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TrydosLoader(),
              ],
            ),
          ));
        }
        return SliverMainAxisGroup(slivers: [
          SliverToBoxAdapter(
              child: Container(
                  width: 1.sw,
                  color: colorScheme.white,
                  child: state.getMyCallsStatus != GetMyCallsStatus.success
                      ? TrydosLoader()
                      : const SizedBox.shrink())),
          sliverListSeparated(
            itemBuilder: (_, index) {
              if (state.callRegister![index].authMessageStatus!.isDeleted ==
                  1) {
                return SizedBox.shrink();
              } else {
                return CallsCard(
                  isMissing:
                      state.callRegister![index].durationInSeconds == -1 &&
                          state.callRegister![index].senderUserId !=
                              GetIt.I<PrefsRepository>().myChatId,
                  createAt: state.callRegister![index].createdAt,
                  isIncome: state.callRegister![index].senderUserId !=
                      GetIt.I<PrefsRepository>().myChatId,
                  index: index,
                  fullReceiverName: state
                      .callRegister![index].channel!.channelName
                      .toString(),
                  photoPath: state.callRegister![index].channel!.photoPath,
                  chatId: state.callRegister![index].channelId.toString(),
                  duration: state.callRegister![index].durationInSeconds == null
                      ? 0
                      : state.callRegister![index].durationInSeconds!,
                  messageType: "",
                  callRegId: state.callRegister![index].id!,
                  isVoice: state.callRegister![index].messageType!.name ==
                      "VoiceCall",
                );
              }
            },
            separator: const SizedBox.shrink(),
            childCount: state.callRegister!.length,
          )
        ]);
      },
    );
  }
}
