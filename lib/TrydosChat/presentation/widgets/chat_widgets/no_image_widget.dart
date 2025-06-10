import 'package:delivery_man_app/TrydosChat/presentation/widgets/my_text_widget.dart';
import 'package:flutter/material.dart';

class NoImageWidget extends StatelessWidget {
  const NoImageWidget(
      {required this.name,
      required this.width,
      required this.textStyle,
      this.thereActivity = false,
      this.withImageShadow = false,
      this.radius = 12,
      required this.height,
      super.key});
  final String name;
  final double width;
  final double height;
  final bool thereActivity;
  final bool withImageShadow;
  final double radius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          boxShadow: thereActivity
              ? [
                  BoxShadow(
                      color: const Color(0xff007CFF).withOpacity(0.16),
                      offset: const Offset(0, 3),
                      blurRadius: 6)
                ]
              : withImageShadow
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        offset: const Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ]
                  : null,
          border: thereActivity
              ? Border.all(color: const Color(0xff007CFF), width: 1)
              : null,
          borderRadius: BorderRadius.circular(radius),
          gradient: const LinearGradient(
            colors: [
              Color(0xffacffe9),
              Color(0xff80baff),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
      child: Center(
        child: MyTextWidget(name, style: textStyle),
      ),
    );
  }
}
