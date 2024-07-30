import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/bmi_entity.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/features/profile/controller/bmi_provider.dart';
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

  //filed category
  bool? isTamLy;
  bool? isHealth;
  bool? isLaw;

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
    //Chỉ gán giá trị khởi tạo
    if (isHealth == null && isLaw == null && isTamLy == null) {
      //Category
      isTamLy = objUser.category.contains(AppConstants.tamly);
      isHealth = objUser.category.contains(AppConstants.health);
      isLaw = objUser.category.contains(AppConstants.law);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = ModalRoute.of(context)!.settings.arguments as bool;
    final fetchUser = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(),
      body: fetchUser.when(
        data: (objUser) {
          init(objUser);
          return _buildContent(context, objUser, _usernameController,
              weightController, heightController, isUpdate);
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
    bool isUpdate,
  ) {
    final bool isExpert = objUser.role == listRoles[1];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Hero(tag: 'avatar', child: ProfileAvatarWidget(avatar: objUser.avatar)),
              SizedBox(height: isExpert ? 20.h : 40.h),
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
              if (isExpert) SizedBox(height: 5.h),
              if (isExpert)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lĩnh vực tư vấn:',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    Row(children: [
                      Checkbox(
                        value: isTamLy,
                        onChanged: (bool? value) {
                          setState(() {
                            isTamLy = value!;
                          });
                        },
                      ),
                      const AppText14('Tâm lý'),
                      const Spacer(),
                      Checkbox(
                        value: isHealth,
                        onChanged: (bool? value) {
                          setState(() {
                            isHealth = value!;
                          });
                        },
                      ),
                      const AppText14('Sức khoẻ'),
                      const Spacer(),
                      Checkbox(
                        value: isLaw,
                        onChanged: (bool? value) {
                          setState(() {
                            isLaw = value!;
                          });
                        },
                      ),
                      const AppText14('Pháp luật'),
                    ]),
                  ],
                ),
              SizedBox(height: isExpert ? 5.h : 20.h),
              ProfileBMIInputWidget(
                objUser: objUser,
                bithController: bithController,
                heightController: heightController,
                weightController: weightController,
              ),
              SizedBox(height: isExpert ? 35.h : 65.h),
              AppButton(
                ontap: () {
                  List<String> categories = [];
                  if (isTamLy ?? false) categories.add(AppConstants.tamly);
                  if (isHealth ?? false) categories.add(AppConstants.health);
                  if (isLaw ?? false) categories.add(AppConstants.law);

                  if (!_formkey.currentState!.validate()) return;
                  String username = userController.text;
                  double weight = double.tryParse(weightController.text)!;
                  double height = double.tryParse(heightController.text)!;
                  final bmi = weight / ((height / 100) * (height / 100));

                  ref.read(profileProvider.notifier).updateUserProfile(
                      username: username,
                      weight: weight,
                      height: height,
                      category: categories);

                  if (isUpdate) {
                    Navigator.pop(context);
                  } else {
                    ref.read(bmiAsyncProvider.notifier).addBMI(
                          BMIEntity(
                            userId: objUser.id,
                            date: DateTime.now(),
                            bmi: bmi,
                            age: objUser.cacularAge(),
                            height: height,
                            weight: weight,
                            gender: objUser.gender,
                          ),
                        );
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutesNames.application, (route) => false);
                  }
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
