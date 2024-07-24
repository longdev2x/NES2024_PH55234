import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_widgets.dart';
import 'package:nes24_ph55234/features/profile/view/profile/profile_widgets.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController weightController;
  late final TextEditingController heightController;
  late final TextEditingController bithController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    weightController = TextEditingController();
    heightController = TextEditingController();
    bithController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    weightController.dispose();
    heightController.dispose();
    bithController.dispose();
  }

  void init(UserEntity objUser) {
    bithController.text = objUser.bithFormat;
    if (weightController.text.isEmpty) {
      weightController.text = objUser.weight?.toString() ?? '';
    }
    if (heightController.text.isEmpty) {
      heightController.text = objUser.height?.toString() ?? '';
    }
    if (_usernameController.text.isEmpty) {
      _usernameController.text = objUser.username;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fetchUser = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(),
      body: fetchUser.when(
        data: (objUser) {
          init(objUser);
          return _buildContent(context, objUser, _usernameController,
              weightController, heightController);
        },
        error: (error, stackTrace) => Center(child: Text('Error-$error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    UserEntity objUser,
    TextEditingController userController,
    TextEditingController weightController,
    TextEditingController heightController,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              ProfileAvatarWidget(avatar: objUser.avatar),
              SizedBox(height: 40.h),
              AppTextFormField(
                lable: 'Username',
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return 'Username cần phải có từ 5 ký tự';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              ProfileBMIInputWidget(
                objUser: objUser,
                bithController: bithController,
                heightController: heightController,
                weightController: weightController,
              ),
              SizedBox(height: 65.h),
              AppButton(
                ontap: () {
                  if (!_formkey.currentState!.validate()) return;
                  String username = userController.text;
                  double weight = double.tryParse(weightController.text)!;
                  double height = double.tryParse(heightController.text)!;
                  ref.read(profileProvider.notifier).updateUserProfile(
                      username: username, weight: weight, height: height);
                  Navigator.pop(context);
                },
                name: 'Lưu Thông Tin',
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
