import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/provider_global/loader_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/features/auth/controller/auth_controller.dart';
import 'package:nes24_ph55234/features/auth/controller/auth_provider.dart';
import 'package:nes24_ph55234/global.dart';

class AuthFormWidget extends ConsumerStatefulWidget {
  const AuthFormWidget({super.key});

  @override
  ConsumerState<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends ConsumerState<AuthFormWidget> {
  late final TextEditingController emailController;
  late final TextEditingController passController;
  late final TextEditingController confirmPassController;
  RememberPassEntity? objRemember;
  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passController = TextEditingController();
    confirmPassController = TextEditingController();

    objRemember = Global.storageService.getRemember();
    if (objRemember != null && objRemember!.isRemember) {
      emailController.text = objRemember != null ? objRemember!.email : '';
      passController.text = objRemember != null ? objRemember!.password : '';
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLogin = ref.watch(isLoginProvider);
    final bool isLoader = ref.watch(loaderProvider);
    final bool? isRemember =
        ref.watch(isRememberProvider(objRemember?.isRemember));
    final Role? role = ref.watch(roleProvider);
    final GlobalKey<FormState> keyForm = GlobalKey();

    return Form(
      key: keyForm,
      child: Column(
        children: [
          AppText40(
            isLogin ? 'Đăng Nhập' : 'Đăng Ký',
            color: Colors.white,
          ),
          if (!isLogin) ...[
            Row(
              children: [
                const Spacer(),
                Radio<String>(
                  activeColor: Colors.white,
                  value: listRoles[0].value,
                  groupValue: role?.value,
                  fillColor: const WidgetStatePropertyAll(Colors.white),
                  onChanged: (value) {
                    ref.read(roleProvider.notifier).state =
                        listRoles.firstWhere((e) => e.value == value);
                  },
                ),
                const AppText14(
                  'Người dùng',
                  color: Colors.white,
                ),
                Radio<String>(
                  value: listRoles[1].value,
                  groupValue: role?.value,
                  activeColor: Colors.white,
                  fillColor: const WidgetStatePropertyAll(Colors.white),
                  onChanged: (value) {
                    ref.read(roleProvider.notifier).state =
                        listRoles.firstWhere((e) => e.value == value);
                  },
                ),
                const AppText14('Chuyên gia', color: Colors.white),
                const Spacer(),
              ],
            ),
          ],
          SizedBox(height: isLogin ? 180.h : 80.h),
          AppTextFormField(
            lable: "Email",
            controller: emailController,
            validator: (value) {
              if (value == null || !value.contains("@")) {
                return "Email không hợp lệ";
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          AppTextFormField(
            lable: "Mật khẩu",
            controller: passController,
            isPass: true,
            validator: (value) {
              if (value == null || value.trim().length < 6) {
                return "Mật khẩu cần từ 6 ký tự";
              }
              return null;
            },
          ),
          if (!isLogin)
            Column(
              children: [
                SizedBox(height: 20.h),
                AppTextFormField(
                  lable: "Xác nhận mật khẩu",
                  controller: confirmPassController,
                  isPass: true,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value != passController.text) {
                      return "Không trùng khớp";
                    }
                    return null;
                  },
                ),
              ],
            ),
          if (isLogin)
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Row(
                children: [
                  Checkbox(
                    value: isRemember,
                    onChanged: (value) => ref
                        .read(isRememberProvider(isRemember).notifier)
                        .state = value,
                  ),
                  Text(
                    'Ghi nhớ tài khoản?',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                          AppRoutesNames.forget,
                          arguments: emailController.text),
                      child: const AppText16(
                        'Quên mật khẩu?',
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          SizedBox(height: isLogin ? 30.h : 30.h),
          AppButton(
            ontap: isLoader
                ? null
                : () {
                    if (keyForm.currentState!.validate()) {
                      final String email = emailController.text;
                      final String password = passController.text;
                      isLogin
                          ? AuthController.signIn(
                              email: email,
                              password: password,
                              isRemember: isRemember ?? false,
                              ref: ref)
                          : AuthController.signUp(
                              email: email,
                              password: password,
                              role: role ?? listRoles[0],
                              ref: ref,
                            );
                    }
                  },
            name: isLogin ? "Đăng nhập" : "Đăng ký",
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText16(
                  isLogin ? "Bạn chưa có tài khoản?" : "Bạn đã có tài khoản?"),
              SizedBox(width: 5.w),
              GestureDetector(
                onTap: isLoader
                    ? null
                    : () {
                        confirmPassController.text = passController.text;
                        ref.read(isLoginProvider.notifier).state = !isLogin;
                        didChangeDependencies.call();
                      },
                child: AppText16(
                  isLogin ? "Đăng ký" : "Đăng Nhập",
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
