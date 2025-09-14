import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final bool isColored1;
  final bool isColored2;
  final bool isColored3;
  final String text1;
  final String text2;
  final String text3;
  final String coloredIcon1;
  final String unColoredIcon1;
  final String coloredIcon2;
  final String coloredIcon3;
  final String unColoredIcon2;
  final String unColoredIcon3;
  final Key? key3;
  final Function() onTap1;
  final Function() onTap2;
  final Function() onTap3;

  const CustomNavBar({
    Key? key,
    required this.isColored1,
    required this.isColored2,
    required this.isColored3,
    required this.onTap1,
    required this.onTap2,
    required this.onTap3,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.coloredIcon1,
    required this.unColoredIcon1,
    required this.coloredIcon2,
    required this.coloredIcon3,
    required this.unColoredIcon2,
    required this.unColoredIcon3,
    this.key3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: isColored1 ? AppColors.primaryDark : AppColors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: isColored3 ? AppColors.primaryDark : AppColors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: isColored2 ? AppColors.primaryDark : AppColors.grey,
                  ),
                ),
              ),
            ],
          ),
          /////////////////////////////
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //////////////////////  1
              Expanded(
                child: GestureDetector(
                  onTap: onTap1,
                  child: Container(
                    height: 55,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          isColored1 ? coloredIcon1 : unColoredIcon1,
                          width: 25,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        TextWidget(
                            text: text1,
                            color: isColored1
                                ? AppColors.primaryDark
                                : AppColors.grey,
                            fontSize: ScreenSizeUtils.getSp(context, 10),
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                            maxline: 1)
                      ],
                    ),
                  ),
                ),
              ),
              ///////////////////
              Container(
                height: 55,
                width: 1,
                decoration: const BoxDecoration(
                  color: AppColors.grey,
                ),
              ),
              ///////////////////
              /////////////////////////  2
              ///
              Expanded(
                child: GestureDetector(
                  onTap: onTap3,
                  key: key3,
                  child: Container(
                    height: 55,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          isColored3 ? coloredIcon3 : unColoredIcon3,
                          width: 25,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        TextWidget(
                            text: text3,
                            color: isColored3
                                ? AppColors.primaryDark
                                : AppColors.grey,
                            fontSize: ScreenSizeUtils.getSp(context, 10),
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                            maxline: 1)
                      ],
                    ),
                  ),
                ),
              ),
               ///////////////////
              Container(
                height: 55,
                width: 1,
                decoration: const BoxDecoration(
                  color: AppColors.grey,
                ),
              ),
              ///////////////////
              Expanded(
                child: GestureDetector(
                  key: const Key('myOrdersTabButton'),
                  onTap: onTap2,
                  child: Container(
                    height: 55,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          isColored2 ? coloredIcon2 : unColoredIcon2,
                          width: 25,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        TextWidget(
                            text: text2,
                            color: isColored2
                                ? AppColors.primaryDark
                                : AppColors.grey,
                            fontSize: ScreenSizeUtils.getSp(context, 10),
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                            maxline: 1)
                      ],
                    ),
                  ),
                ),
              ),
             
              
            ],
          ),
        ],
      ),
    );
  }
}
