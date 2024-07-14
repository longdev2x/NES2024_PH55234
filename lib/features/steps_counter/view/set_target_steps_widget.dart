import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';

class SetTargetStepsWidget extends StatefulWidget {
  const SetTargetStepsWidget({super.key});

  @override
  State<SetTargetStepsWidget> createState() => _SetTargetStepsWidgetState();
}

class _SetTargetStepsWidgetState extends State<SetTargetStepsWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final TextEditingController _stepsController;
  late final TextEditingController _caloController;
  late final TextEditingController _metreController;
  late final TextEditingController _minutesController;
  @override
  void initState() {
    super.initState();
    _stepsController = TextEditingController();
    _caloController = TextEditingController();
    _metreController = TextEditingController();
    _minutesController = TextEditingController();
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
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(children: [
          const AppText24('Đặt mục tiêu ngay nhé'),
          AppTextFormField(
            controller: _stepsController,
            hintText: 'Số bước',
            validator: (value) {
              int? num = int.tryParse(value ?? '');
              if (num == null || num < 100) {
                return 'Hãy đặt mục tiêu từ 100 nhé';
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),
          AppTextFormField(
            controller: _caloController,
            hintText: 'Đốt bao nhiêu Calo',
            validator: (value) {
              int? num = int.tryParse(value ?? '');
              if (num == null || num < 5) {
                return 'Hãy đặt mục tiêu từ 5 Calo nhé';
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),
          AppTextFormField(
            controller: _metreController,
            hintText: 'Bao xa (m)',
            validator: (value) {
              int? num = int.tryParse(value ?? '');
              if (num == null || num < 500) {
                return 'Hãy đặt mục tiêu từ 500m nhé';
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),
          AppTextFormField(
            controller: _minutesController,
            hintText: 'Trong bao lâu (phút)',
            validator: (value) {
              int? num = int.tryParse(value ?? '');
              if (num == null || num < 5) {
                return 'Hãy đặt mục tiêu từ 5 phút nhé';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          AppButton(
            ontap: () {
              if(!_formKey.currentState!.validate()) return;
              
            },
            name: 'Chốt luôn',
          ),
        ]),
      ),
    );
  }
}
