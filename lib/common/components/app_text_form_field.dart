import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';

class AppTextFormField extends StatelessWidget {
  final String? hintText;
  final String? lable;
  final bool? isPass;
  final bool? autofocus;
  final String? initialValue;
  final TextInputType? inputType;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onSaved;
  final Function(String? value)? onChanged;
  final TextEditingController? controller;
  const AppTextFormField(
      {super.key,
      this.hintText = "",
      this.lable = '',
      this.isPass = false,
      this.validator,
      this.onChanged,
      this.initialValue,
      this.inputType,
      this.autofocus = false,
      this.controller,
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
      obscureText: isPass!,
      initialValue: initialValue,
      autofocus: autofocus ?? false,
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        label: AppText16(lable ?? '',color: AppColors.primaryThreeElementText,),
        hintText: hintText,
        enabledBorder: _customOutline(borderColor: Colors.blue),
        focusedBorder: _customOutline(),
        errorBorder: _customOutline(borderColor: Colors.red),
        focusedErrorBorder: _customOutline(borderColor: Colors.red),
        disabledBorder: _customOutline(),
      ),
    );
  }

  OutlineInputBorder _customOutline({Color borderColor = Colors.black}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: borderColor,
      ),
    );
  }
}

class AppTextFieldNoborder extends StatelessWidget {
  final double? height;
  final double? width;
  final int? maxLines;
  final int? maxLength;
  final Function()? onTap;
  final Function(String)? onChanged;
  final TextInputType? inputType;
  final TextInputAction? action;
  final TextEditingController? controller;
  final String? hintText;
  final EdgeInsets? paddingContent;
  final double? fontSize;
  final FontWeight? fontWeight;
  const AppTextFieldNoborder(
      {super.key,
      this.onTap,
      this.onChanged,
      this.height,
      this.width = 280,
      this.action = TextInputAction.none,
      this.maxLines,
      this.maxLength,
      this.controller,
      this.inputType,
      this.hintText,
      this.paddingContent,
      this.fontSize,
      this.fontWeight});
  @override
  Widget build(context) {
    return SizedBox(
      width: width!.w,
      height: height,
      child: TextField(
        textAlignVertical: TextAlignVertical.bottom,
        controller: controller,
        textInputAction: action,
        keyboardType: inputType,
        maxLines: maxLines,
        minLines: 1,
        onTap: onTap,
        onChanged: onChanged,
        maxLength: maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: paddingContent,
          border: _outlineInputBorder(),
          errorBorder: _outlineInputBorder(),
          enabledBorder: _outlineInputBorder(),
          focusedBorder: _outlineInputBorder(),
          focusedErrorBorder: _outlineInputBorder(),
        ),
      ),
    );
  }

  OutlineInputBorder _outlineInputBorder() {
    return const OutlineInputBorder(borderSide: BorderSide.none);
  }
}
