import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildCashDialogAction({
  required Key formKey,
  required TextEditingController cashKey,
  required String cashAmount,
  void Function()? onPress,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            textInputType: TextInputType.number,
            controller: cashKey,
            hintText: cashAmount,
            labelText: 'Cash Amount'.tr,
            validator: (value) {
              if (value.isEmpty) {
                return 'Cash Amount should not be empty'.tr;
              }
            },
            prefixIcon: null,
            suffixIcon: null,
          ),
          /////////////////////
          const SizedBox(
            height: 30,
          ),
          /////////////////////
          AppButton.normalButton(
            title: 'Confirm The Process'.tr,
            shadow: false,
            height: 35,
            titleColor: AppColors.white,
            backgroundColor: AppColors.primaryDark,
            onPress: onPress,
          ),
          /////////////////////
          const SizedBox(
            height: 20,
          ),
          /////////////////////
        ],
      ),
    ),
  );
}
