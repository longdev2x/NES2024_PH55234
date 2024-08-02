import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/features/auth/controller/auth_controller.dart';

class ForgetScreen extends ConsumerStatefulWidget {
  const ForgetScreen({super.key});

  @override
  ConsumerState<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends ConsumerState<ForgetScreen> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _controller;
  }
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> key = GlobalKey();
    final String name = ModalRoute.of(context)!.settings.arguments as String;
    _controller.text = name;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const AppText24('Tìm tài khoản', fontWeight: FontWeight.bold),
          SizedBox(height: 5.h),
          const AppText16(' Nhập email của bạn.'),
          SizedBox(height: 30.h),
          Form(
            key: key,
            child: AppTextFormField(
              lable: 'Email',
              controller: _controller,
              validator: (value) {
                if (value == null || !value.contains("@")) return 'Email không hợp lệ';
                return null;
              },
              autofocus: true,
            ),
          ),
          SizedBox(height: 35.h),
          AppButton(ontap: () {
            if(!key.currentState!.validate()) return;
            AuthController.forgot(_controller.text, ref);
          },name: 'Tiếp tục')
        ]),
      ),
    );
  }
}
