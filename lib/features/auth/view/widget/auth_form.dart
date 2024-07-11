import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/provider_global/loader_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/features/auth/controller/auth_controller.dart';
import 'package:nes24_ph55234/features/auth/controller/auth_provider.dart';

class AuthFormWidget extends ConsumerStatefulWidget {
  const AuthFormWidget({super.key});

  @override
  ConsumerState<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends ConsumerState<AuthFormWidget> {
  late final TextEditingController emailController;
  late final TextEditingController passController;
  late final TextEditingController confirmPassController;

  @override
  void initState() {
    emailController = TextEditingController();
    passController = TextEditingController();
    confirmPassController = TextEditingController();
    super.initState();
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
    final GlobalKey<FormState> keyForm = GlobalKey();

    return Form(
      key: keyForm,
      child: Column(
        children: [
          SizedBox(height: isLogin ? 20.h : 0),
          AppTextFormField(
            hintText: "Email",
            controller: emailController,
            validator: (value) {
              if (value == null || !value.contains("@")) {
                return "Email is not valid";
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          AppTextFormField(
            hintText: "Password",
            controller: passController,
            isPass: true,
            validator: (value) {
              if (value == null || value.trim().length < 6) {
                return "Username needs at least than 6 characters";
              }
              return null;
            },
          ),
          if (!isLogin)
            Column(
              children: [
                SizedBox(height: 20.h),
                AppTextFormField(
                  hintText: "Confirm Password",
                  controller: confirmPassController,
                  isPass: true,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value != passController.text) {
                      return "Repassword not same";
                    }
                    return null;
                  },
                ),
              ],
            ),
          SizedBox(height: isLogin ? 50.h : 20.h),
          AppButton(
            ontap: isLoader
                ? null
                : () {
                    if (keyForm.currentState!.validate()) {
                      final String email = emailController.text;
                      final String password = passController.text;
                      isLogin
                          ? AuthController.signIn(
                              email: email, password: password, ref: ref)
                          : AuthController.signUp(
                              email: email, password: password, ref: ref);
                    }
                  },
            name: isLogin ? "Login" : "SignUp",
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isLogin
                  ? "Don't have an account?"
                  : "You already have an account?"),
              SizedBox(width: 5.w),
              GestureDetector(
                onTap: isLoader
                    ? null
                    : () {
                        confirmPassController.text = passController.text;
                        ref.read(isLoginProvider.notifier).state = !isLogin;
                        didChangeDependencies.call();
                      },
                child: Text(
                  isLogin ? "SignUp" : "SignIn",
                  style: const TextStyle(
                      color: Colors.purple, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
