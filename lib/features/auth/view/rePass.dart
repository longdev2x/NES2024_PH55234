import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/features/auth/controller/auth_controller.dart';

class RePassScreen extends ConsumerStatefulWidget {
  const RePassScreen({super.key});

  @override
  ConsumerState<RePassScreen> createState() => _RePassScreenState();
}

class _RePassScreenState extends ConsumerState<RePassScreen> {
  late final TextEditingController _currentPass;
  late final TextEditingController _newPass;
  late final TextEditingController _confirmPass;
  @override
  void initState() {
    super.initState();
    _currentPass = TextEditingController();
    _newPass = TextEditingController();
    _confirmPass = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _currentPass.dispose();
    _newPass.dispose();
    _confirmPass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> key = GlobalKey();
    final String email = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const AppText24('Đổi mật khẩu', fontWeight: FontWeight.bold),
          SizedBox(height: 5.h),
          const AppText16(' Mập khẩu của bạn phải có tối thiểu 6 ký tự.'),
          SizedBox(height: 30.h),
          Form(
            key: key,
            child: Column(
              children: [
                AppTextFormField(
                  lable: 'Mật khẩu hiện tại',
                  controller: _currentPass,
                  validator: (value) {
                    if (value == null || value.trim().length < 6) return 'vui lòng nhập từ 6 ký tự';
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                AppTextFormField(
                  lable: 'Mật khẩu mới',
                  isPass: true,
                  controller: _newPass,
                  validator: (value) {
                    if (value == null || value.trim().length < 6) return 'vui lòng nhập từ 6 ký tự';
                    if(value == _currentPass.text) return 'Không được trùng với mật khẩu cũ';
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                AppTextFormField(
                  lable: 'Nhập lại mật khẩu mới',
                  controller: _confirmPass,
                  isPass: true,
                  validator: (value) {
                    if (value == null || value.trim().length < 6) return 'vui lòng nhập từ 6 ký tự';
                    if(value != _newPass.text) return 'Không trùng khớp';
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 35.h),
          AppButton(
              ontap: () {
                if (!key.currentState!.validate()) return;
                AuthController.changePass(email, _currentPass.text, _newPass.text, ref);
              },
              name: 'Đổi mật khẩu')
        ]),
      ),
    );
  }
}
