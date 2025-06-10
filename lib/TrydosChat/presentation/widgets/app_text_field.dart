import 'package:delivery_man_app/TrydosChat/presentation/utils/constant_design.dart';
import 'package:delivery_man_app/TrydosChat/presentation/utils/responsive_padding.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.onTap,
    this.onEditingComplete,
    this.onChange,
    this.onFieldSubmitted,
    this.onSaved,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.enabled,
    this.textInputType,
    this.textInputAction,
    this.textDirection,
    this.validator,
    this.maxLengthEnforcement,
    this.focusNode,
    this.autoValidateMode,
    this.scrollPhysics,
    this.scrollController,
    this.initialValue,
    this.keyboardAppearance,
    this.textAlignVertical,
    this.toolbarOptions,
    this.obscuringCharacter = "•",
    this.expands = false,
    this.readOnly = false,
    this.autocorrect = true,
    this.showLength = false,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.titleField,
    this.obscure = false,
    this.prefixIcon,
    this.icon,
    this.hintTextStyle,
    this.textStyle,
    this.suffixIcon,
    this.suffix,
    this.prefix,
    this.hintText,
    this.labelText,
    this.inputFormatters,
    this.autoFocus,
    this.contentPadding,
    this.roundingCornersValue,
    this.filledColor,
    this.isErrorBorder = true,
    this.bordersColor,
    this.isPrefixIconConstraints = true,
  });

  final TextEditingController? controller;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final void Function(String val)? onChange;
  final void Function(String val)? onFieldSubmitted;
  final void Function(String? val)? onSaved;
  final int? maxLines;
  final int? minLines;
  final bool isErrorBorder;
  final int? maxLength;
  final bool? enabled;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final TextDirection? textDirection;
  final FormFieldValidator<String?>? validator;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final FocusNode? focusNode;
  final AutovalidateMode? autoValidateMode;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final String? initialValue;
  final Brightness? keyboardAppearance;
  final TextAlignVertical? textAlignVertical;
  final ToolbarOptions? toolbarOptions;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final EdgeInsets scrollPadding;
  final bool expands;
  final bool readOnly;
  final bool autocorrect;
  final String obscuringCharacter;
  final String? titleField;
  final bool showLength;
  final bool obscure;
  final bool? autoFocus;
  final Widget? prefixIcon;
  final Widget? icon;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final Color? filledColor;
  final Color? bordersColor;
  final double? roundingCornersValue;
  final bool isPrefixIconConstraints;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTap: onTap,
      onChanged: onChange,
      onFieldSubmitted: onFieldSubmitted,
      onEditingComplete: onEditingComplete,
      onSaved: onSaved,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: showLength ? maxLength : null,
      textAlign: textAlign,
      enabled: enabled,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      textDirection: textDirection,
      scrollPadding: scrollPadding,
      expands: expands,
      maxLengthEnforcement: maxLengthEnforcement,
      focusNode: focusNode,
      obscureText: obscure,
      obscuringCharacter: obscuringCharacter,
      autovalidateMode: autoValidateMode,
      readOnly: readOnly,
      scrollPhysics: scrollPhysics,
      scrollController: scrollController,
      autocorrect: false,
      autofocus: autoFocus ?? false,
      cursorColor: AppColors.primaryDark,
      initialValue: initialValue,
      keyboardAppearance: keyboardAppearance,
      textAlignVertical: textAlignVertical,
      textCapitalization: textCapitalization,
      toolbarOptions: toolbarOptions,
      inputFormatters: [
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        if (textInputType == TextInputType.phone ||
            textInputType == TextInputType.number)
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        ...?inputFormatters
      ],
      style: textStyle ??
          const TextStyle(
            color: Color(0xff404040),
            decoration: TextDecoration.none,
          ),
      // context.textTheme.displayMedium?.rr.copyWith(
      //   color: const Color(0xff404040),
      //   decoration: TextDecoration.none,
      //   decorationColor: context.colorScheme.borderTextField,
      // ),
      decoration: InputDecoration(
        errorMaxLines: 1,
        errorStyle: const TextStyle(
          color: Color.fromARGB(255, 201, 22, 22),
          letterSpacing: 0.18,
          fontSize: 11,
          height: 0.8,
        ),
        // context.textTheme.bodyMedium?.mr.copyWith(
        //   color: const Color.fromARGB(255, 201, 22, 22),
        //   letterSpacing: 0.18,
        //   fontSize: 11,
        //   height: 0.8,
        // ),
        prefix: prefix,
        prefixIconConstraints: isPrefixIconConstraints
            ? const BoxConstraints(
                maxWidth: 2, maxHeight: 2, minHeight: 2, minWidth: 2)
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: bordersColor ?? const Color(0xFFC7C7C7),
            width: 0.4,
          ),
          borderRadius:
              BorderRadius.circular(roundingCornersValue ?? kbrBorderTextField),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: bordersColor ?? const Color(0xFFC7C7C7),
            width: 0.4,
          ),
          borderRadius:
              BorderRadius.circular(roundingCornersValue ?? kbrBorderTextField),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: bordersColor ?? const Color(0xFFC7C7C7), width: 0.4),
          borderRadius:
              BorderRadius.circular(roundingCornersValue ?? kbrBorderTextField),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: bordersColor ?? const Color(0xFFC7C7C7), width: 0.4),
          borderRadius:
              BorderRadius.circular(roundingCornersValue ?? kbrBorderTextField),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: !isErrorBorder ? bordersColor! : Colors.red, width: 0.4),
          borderRadius:
              BorderRadius.circular(roundingCornersValue ?? kbrBorderTextField),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: !isErrorBorder ? bordersColor! : Colors.red, width: 0.4),
          borderRadius:
              BorderRadius.circular(roundingCornersValue ?? kbrBorderTextField),
        ),
        filled: true,
        fillColor: filledColor ?? Colors.white,
        contentPadding: contentPadding ??
            HWEdgeInsetsDirectional.only(
                start: 20, end: 10, bottom: 12, top: 12),
        prefixIcon: prefixIcon,
        icon: icon,
        suffixIcon: suffixIcon,
        suffix: suffix,
        hintText: hintText?.tr,
        hintStyle: hintTextStyle ?? const TextStyle(color: Colors.grey),
        labelText: labelText?.tr,
        labelStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
