import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/target_entity.dart';
import 'package:nes24_ph55234/features/step/controller/target_provider.dart';

class SetTargetStepsWidget extends ConsumerStatefulWidget {
  final bool isDaily;
  const SetTargetStepsWidget({super.key, required this.isDaily});

  @override
  ConsumerState<SetTargetStepsWidget> createState() =>
      _SetTargetStepsWidgetState();
}

class _SetTargetStepsWidgetState extends ConsumerState<SetTargetStepsWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final TextEditingController _stepsController;
  late final TextEditingController _caloController;
  late final TextEditingController _metreController;
  late final TextEditingController _minutesController;
  String typeStep = '';
  String typeMetre = '';
  String typeCalo = '';
  String typeMinute = '';
  double? step;
  double? metre;
  double? calo;
  double? minute;

  @override
  void initState() {
    super.initState();
    _stepsController = TextEditingController();
    _caloController = TextEditingController();
    _metreController = TextEditingController();
    _minutesController = TextEditingController();

    if (widget.isDaily) {
      typeStep = AppConstants.typeStepDaily;
      typeMetre = AppConstants.typeMetreDaily;
      typeCalo = AppConstants.typeCaloDaily;
      typeMinute = AppConstants.typeMinuteDaily;
    } else {
      typeStep = AppConstants.typeStepCounter;
      typeMetre = AppConstants.typeMetreCounter;
      typeCalo = AppConstants.typeCaloCounter;
      typeMinute = AppConstants.typeMinuteCounter;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stepsController.dispose();
    _caloController.dispose();
    _metreController.dispose();
    _minutesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Type
    final TargetAsyncNotifier stepNotifier =
        ref.watch(targetAsyncFamilyProvider(typeStep).notifier);
    final AsyncValue<TargetEntity?> fetchTargetStep =
        ref.watch(targetAsyncFamilyProvider(typeStep));

    final TargetAsyncNotifier metreNotifier =
        ref.watch(targetAsyncFamilyProvider(typeMetre).notifier);
    final AsyncValue<TargetEntity?> fetchTargetmetre =
        ref.watch(targetAsyncFamilyProvider(typeMetre));

    final TargetAsyncNotifier caloNotifier =
        ref.watch(targetAsyncFamilyProvider(typeCalo).notifier);
    final AsyncValue<TargetEntity?> fetchTargetCalo =
        ref.watch(targetAsyncFamilyProvider(typeCalo));

    final TargetAsyncNotifier minuteNotifier =
        ref.watch(targetAsyncFamilyProvider(typeMinute).notifier);
    final AsyncValue<TargetEntity?> fetchTargetMinute =
        ref.watch(targetAsyncFamilyProvider(typeMinute));

    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppText24('Đặt mục tiêu bạn nhé', textAlign: TextAlign.center,),
          SizedBox(height: 20.w),
          fetchTargetStep.when(
            data: (data) {
              _stepsController.text = data?.target.toInt().toString() ?? '';
              return AppTextFormField(
                controller: _stepsController,
                lable: 'Số bước',
                validator: (value) {
                  step = double.tryParse(value ?? '');
                  if (step == null) {
                    return 'Hãy chỉ nhập số';
                  }
                  if (step! < 100) {
                    return 'Hãy đặt mục tiêu từ 100 nhé';
                  }
                  return null;
                },
                inputType: TextInputType.number,
              );
            },
            error: (error, stackTrace) => const Text('Error'),
            loading: () => const AppTextFormField(
              lable: 'Số bước',
            ),
          ),
          SizedBox(height: 20.h),
          fetchTargetCalo.when(
            data: (data) {
              _caloController.text = data?.target.toInt().toString() ?? '';
              return AppTextFormField(
                controller: _caloController,
                lable: 'Số Calo',
                validator: (value) {
                  calo = double.tryParse(value ?? '');
                  if (calo == null) {
                    return 'Hãy chỉ nhập số';
                  }
                  if (calo! < 5) {
                    return 'Hãy đặt mục tiêu từ 5Kcal nhé';
                  }
                  return null;
                },
                inputType: TextInputType.number,
              );
            },
            error: (error, stackTrace) => const Text('Error'),
            loading: () => const AppTextFormField(
              lable: 'Số Calo',
            ),
          ),
          SizedBox(height: 20.h),
          fetchTargetmetre.when(
            data: (data) {
              _metreController.text = data?.target.toInt().toString() ?? '';
              return AppTextFormField(
                controller: _metreController,
                lable: 'Bao xa (m)',
                validator: (value) {
                  metre = double.tryParse(value ?? '');
                  if (metre == null) {
                    return 'Hãy chỉ nhập số';
                  }
                  if (metre! < 100) {
                    return 'Hãy đặt mục tiêu từ 100m nhé';
                  }
                  return null;
                },
                inputType: TextInputType.number,
              );
            },
            error: (error, stackTrace) => const Text('Error'),
            loading: () => const AppTextFormField(
              lable: 'Bao xa (m)',
            ),
          ),
          SizedBox(height: 20.h),
          fetchTargetMinute.when(
            data: (data) {
              _minutesController.text = data?.target.toInt().toString() ?? '';
              return AppTextFormField(
                controller: _minutesController,
                lable: 'Bao lâu (phút)',
                validator: (value) {
                  minute = double.tryParse(value ?? '');
                  if (minute == null) {
                    return 'Hãy chỉ nhập số';
                  }
                  if (minute! < 10) {
                    return 'Hãy đặt mục tiêu từ 10 phút nhé';
                  }
                  return null;
                },
                inputType: TextInputType.number,
              );
            },
            error: (error, stackTrace) => const Text('Error'),
            loading: () => const AppTextFormField(
              lable: 'Bao lâu (phút)',
            ),
          ),
          SizedBox(height: 20.h),
          AppButton(
            ontap: () {
              if (!_formKey.currentState!.validate()) return;
              stepNotifier.updateTarget(target: step!);
              metreNotifier.updateTarget(target: metre!);
              caloNotifier.updateTarget(target: calo!);
              minuteNotifier.updateTarget(target: minute!);
              Navigator.pop(context);
            },
            name: 'Chốt luôn',
          ),
        ]),
      ),
    );
  }
}
