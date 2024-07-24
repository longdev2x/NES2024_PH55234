import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/user_entity.dart';
import 'package:nes24_ph55234/features/profile/controller/profile_provider.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_widgets.dart';

class BMICalculateScreen extends ConsumerStatefulWidget {
  const BMICalculateScreen({super.key});

  @override
  ConsumerState createState() => _BMICalculateScreenState();
}

class _BMICalculateScreenState extends ConsumerState<BMICalculateScreen> {
  late final TextEditingController weightController;
  late final TextEditingController heightController;
  late final TextEditingController bithController;

  @override
  void initState() {
    super.initState();
    weightController = TextEditingController();
    heightController = TextEditingController();
    bithController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
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
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(profileProvider);

    return Scaffold(
      appBar: appGlobalAppBar('BMI'),
      body: userAsyncValue.when(
        data: (objUser) {
          init(objUser);
          return _buildContent(context, objUser);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserEntity objUser) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.marginHori,
            vertical: AppConstants.marginVeti),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppText40('Chỉ số hiện tại'),
            SizedBox(height: 60.h),
            ProfileBMIInputWidget(
              objUser: objUser,
              isBMI: true,
              bithController: bithController,
              heightController: heightController,
              weightController: weightController,
            ),
          ],
        ),
      ),
    );
  }
}
