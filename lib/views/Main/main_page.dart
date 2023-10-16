import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/Auth/auth_controller.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          InkWell(
            onTap: () {
              print(GlobalFunctions.getFcmToken());
            },
            child: Container(
              width: 500,
              height: 200,
              color: AppColors.primaryDark,
            ),
          )
        ]),
      ),
    );
  }
}
