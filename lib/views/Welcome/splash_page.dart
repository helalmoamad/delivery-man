import 'dart:async';
import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_bloc.dart'
    show ChatBloc;
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_event.dart';
import 'package:delivery_man_app/controllers/Auth/auth_controller.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/global_functions/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../routes/routes.dart';
import '../../shared/constants/color_constants.dart';
import '../../shared/helpers/screen_size_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool selected = false;
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      goToHomeScreen();
    });
  }

  goToHomeScreen() {
    GlobalFunctions.getIsLoggedIn() == true
        ? Get.offNamed(Routes.orderssPage)
        : Get.offNamed(Routes.insertNumberPage);
  }

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitFadingFour(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? AppColors.primaryDark : AppColors.secondary,
          ),
        );
      },
    );
    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //////////////////////////
          SizedBox(
            height: ScreenSizeUtils.getHeightInPercent(context, 10),
          ),
          ///////////////////////////
          Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/pictures/logo.png',
                      ),
                      fit: BoxFit.cover))),
          //////////////////////////
          SizedBox(
            height: ScreenSizeUtils.getHeightInPercent(context, 20),
          ),
          ///////////////////////////
          spinkit,
        ],
      )),
    );
  }
}
