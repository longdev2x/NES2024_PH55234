import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/utils/app_colors.dart';

class AppText10 extends StatelessWidget {
  final String? text;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? color;
  const AppText10(this.text,
      {super.key,
      this.fontWeight,
      this.maxLines = 1,
      this.textAlign,
      this.color});
  @override
  Widget build(context) {
    return Text(
      text!,
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: fontWeight,
        color: color,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class AppText14 extends StatelessWidget {
  final String? text;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? color;
  const AppText14(this.text,
      {super.key,
      this.fontWeight,
      this.maxLines = 1,
      this.textAlign,
      this.color});
  @override
  Widget build(context) {
    return Text(
      text!,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: fontWeight,
        color: color,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class AppText16 extends StatelessWidget {
  final String? text;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? color;
  const AppText16(this.text,
      {super.key,
      this.fontWeight,
      this.maxLines = 1,
      this.textAlign,
      this.color});
  @override
  Widget build(context) {
    return Text(
      text!,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: fontWeight,
        color: color,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class AppText20 extends StatelessWidget {
  final String? text;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? color;
  const AppText20(this.text,
      {super.key,
      this.fontWeight,
      this.maxLines = 1,
      this.textAlign,
      this.color});
  @override
  Widget build(context) {
    return Text(
      text!,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: fontWeight,
        color: color,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class AppText24 extends StatelessWidget {
  final String? text;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? color;
  const AppText24(this.text,
      {super.key,
      this.fontWeight = FontWeight.bold,
      this.maxLines = 1,
      this.textAlign,
      this.color});
  @override
  Widget build(context) {
    return Text(
      text!,
      style: TextStyle(
        fontSize: 24.sp,
        fontWeight: fontWeight,
        color: color,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class AppText26 extends StatelessWidget {
  final String? text;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? color;
  const AppText26(this.text,
      {super.key,
      this.fontWeight = FontWeight.bold,
      this.maxLines = 1,
      this.textAlign,
      this.color});
  @override
  Widget build(context) {
    return Text(
      text!,
      style: TextStyle(fontSize: 26.sp, fontWeight: fontWeight, color: color),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class AppText28 extends StatelessWidget {
  final String? text;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? color;
  const AppText28(this.text,
      {super.key,
      this.fontWeight = FontWeight.bold,
      this.maxLines = 1,
      this.textAlign,
      this.color});
  @override
  Widget build(context) {
    return Text(
      text!,
      style: TextStyle(fontSize: 28.sp, fontWeight: fontWeight, color: color),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class AppText34 extends StatelessWidget {
  final String? text;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? color;
  const AppText34(this.text,
      {super.key,
      this.fontWeight = FontWeight.bold,
      this.maxLines = 1,
      this.textAlign,
      this.color});
  @override
  Widget build(context) {
    return Text(
      text!,
      style: TextStyle(fontSize: 34.sp, fontWeight: fontWeight, color: color),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class AppText40 extends StatelessWidget {
  final String? text;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? color;
  const AppText40(this.text,
      {super.key,
      this.fontWeight = FontWeight.bold,
      this.maxLines = 1,
      this.textAlign,
      this.color});
  @override
  Widget build(context) {
    return Text(
      text!,
      style: TextStyle(fontSize: 40.sp, fontWeight: fontWeight, color: color),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class AppText55 extends StatelessWidget {
  final String? text;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final Color? color;
  const AppText55(this.text,
      {super.key,
      this.fontWeight = FontWeight.bold,
      this.maxLines = 1,
      this.textAlign,
      this.color});
  @override
  Widget build(context) {
    return Text(
      text!,
      style: TextStyle(fontSize: 55.sp, fontWeight: fontWeight, color: color),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class AppTextSpan extends StatelessWidget {
  final String? text;
  final String? textButton;
  final String? textSecond;
  final double? fontSize;
  final Function()? onTap;
  const AppTextSpan(
      {super.key,
      this.text = '',
      this.textButton = '',
      this.textSecond = '',
      this.fontSize = 13,
      this.onTap});
  @override
  Widget build(context) {
    return RichText(text: TextSpan(
      text: text,
      style: TextStyle(color: AppColors.primaryText, fontSize: fontSize!.sp),
      children: [
        WidgetSpan(child: SizedBox(width: 4.w)),
        TextSpan(
          text: textButton,
          style: const TextStyle(color: AppColors.primaryElement, fontWeight: FontWeight.w700),
          recognizer: TapGestureRecognizer()..onTap = onTap,
        ),
        WidgetSpan(child: SizedBox(width: 4.w)),
        TextSpan(
          text: textSecond
        ),
      ],
    ));
  }
}


class FadeText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final int maxLines;
  final TextOverflow textOverflow;
  
  const FadeText(
      {super.key,
      required this.text,
      this.maxLines = 1,
      this.fontSize = 10,
      this.textOverflow = TextOverflow.fade,
      this.color = AppColors.primaryElementText});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      softWrap: null,
      maxLines: maxLines,
      overflow: textOverflow,
      style: TextStyle(
        color: color,
        fontSize: fontSize.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
