import 'package:delivery_man_app/TrydosChat/chat_utils/assets_provider.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/build_context.dart';
import 'package:delivery_man_app/TrydosChat/config/theme/my_color_scheme.dart';
import 'package:delivery_man_app/TrydosChat/presentation/widgets/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'app_bar_params.dart';

class TrydosAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TrydosAppBar({
    Key? key,
    required this.appBarParams,
    this.heightAppBar,
  }) : super(key: key);

  final AppBarParams appBarParams;
  final double? heightAppBar;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              boxShadow: appBarParams.withShadow
                  ? [
                      BoxShadow(
                          color: context.colorScheme.black.withOpacity(0.1),
                          offset: Offset(0, 0),
                          blurRadius: 6)
                    ]
                  : null),
          child: AppBar(
            scrolledUnderElevation: appBarParams.scrolledUnderElevation,
            backgroundColor: appBarParams.backgroundColor ??
                Theme.of(context).colorScheme.surface,
            leading: null,
            actions: [
              SizedBox.shrink(),
              ...appBarParams.action ?? [],
            ],
            centerTitle: appBarParams.centerTitle,
            elevation: appBarParams.elevation,
            shadowColor: appBarParams.shadowColor,
            surfaceTintColor: appBarParams.surfaceTintColor,
            leadingWidth: 45.w,
            shape: appBarParams.shape,
            automaticallyImplyLeading: appBarParams.automaticallyImplyLeading,
            flexibleSpace: appBarParams.child,
            bottom: appBarParams.bottom,
          ),
        ),
        if (appBarParams.dividerBottom)
          Divider(height: 0, endIndent: 25.w, indent: 25.w)
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight((heightAppBar ?? null) == null ? 56 : heightAppBar ?? 56);

  Widget title(BuildContext context) {
    return Transform.translate(
      offset: Offset((appBarParams.action?.isNotEmpty ?? true) ? 0 : (-30), 0),
      child: Row(
        mainAxisAlignment: appBarParams.centerTitle
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (appBarParams.child != null) ...{
            5.horizontalSpace,
            appBarParams.child!,
          },
          if (appBarParams.title != null)
            MyTextWidget(
              appBarParams.title!,
              style: appBarParams.tittleStyle ??
                  Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: appBarParams.textColor,
                      ),
            ),
        ],
      ),
    );
  }

  Widget leadingAppBar(BuildContext context, {Widget? leading}) =>
      appBarParams.hasLeading
          ? Row(
              children: [
                InkWell(
                  key: null,
                  onTap: () {
                    appBarParams.onBack?.call();
                    Navigator.pop(context);
                    /////////////////////////////////
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 14.w, right: 14.w),
                    child: SvgPicture.asset(
                      AppAssets.backIconArrowSvg,
                      matchTextDirection: true,
                      width: 12.w,
                      color:
                          appBarParams.backIconColor ?? const Color(0xff388CFF),
                    ),
                  ),
                ),
                if (leading != null) ...{
                  SizedBox(
                    width: 10,
                  ),
                  leading
                }
              ],
            )
          : const SizedBox();
}
