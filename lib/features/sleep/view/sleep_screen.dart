import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_icon.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';
import 'package:nes24_ph55234/data/models/sleep_entity.dart';
import 'package:nes24_ph55234/data/models/target_entity.dart';
import 'package:nes24_ph55234/features/sleep/controller/sleep_provider.dart';
import 'package:nes24_ph55234/features/sleep/controller/sleep_target_provider.dart';

class SleepScreen extends ConsumerStatefulWidget {
  const SleepScreen({super.key});

  @override
  ConsumerState<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends ConsumerState<SleepScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      ref.read(currentTimeProvider.notifier).state = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatTime(DateTime date) {
    DateFormat format = DateFormat('HH:mm');
    return format.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final listSleep = ref.watch(sleepProvider);
    ref.watch(currentTimeProvider);
    return Scaffold(
      appBar: appGlobalAppBar('Sleep Tracker'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            listSleep.isEmpty ||
                    (listSleep.first.startTime != null &&
                        listSleep.first.endTime != null)
                ? _buildStartTracker(ref: ref, listSleeps: listSleep)
                : _buildStopTracker(ref: ref, listSleeps: listSleep),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStartTracker(
      {required WidgetRef ref, required List<SleepEntity> listSleeps}) {
    SleepEntity? currentSleep;
    int? totalSlep;
    String? textTotalDuration;
    if (listSleeps.isNotEmpty) {
      currentSleep = listSleeps.first;
      totalSlep =
          currentSleep.endTime!.difference(currentSleep.startTime!).inMinutes;
      textTotalDuration = 'Ngủ được: ${totalSlep}phút';
      if (totalSlep > 60) {
        textTotalDuration = 'Ngủ được: ${totalSlep / 60}giờ';
      }
    }

    final fetchSleepTarget = ref.watch(sleepTargetProvider);
    final TimeOfDay timeTellSleep = ref.read(planBedProvider);

    return Column(
      children: [
        const SizedBox(width: double.infinity),
        fetchSleepTarget.when(
            data: (target) {
              return Column(
                children: [
                  AppText20('Mục tiêu: ${target!.target} (giờ)', fontWeight: FontWeight.bold,),
                  SizedBox(height: 5.h),
                  AppText16('Giờ nhắc ngủ: ${timeTellSleep.format(context)}', fontWeight: FontWeight.bold),
                  SizedBox(height: 10.h),
                  TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return const SleepSetupDialogWidget();
                            });
                      },
                      child: const AppText16('Thiết lập lại'),),
                ],
              );
            },
            error: (e, s) => const Center(
                  child: Text('Error'),
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )),
        SizedBox(height: 50.h),
        AppButton(
          ontap: () {
            ref
                .read(sleepProvider.notifier)
                .startSleep(startTime: DateTime.now());
          },
          width: 270,
          name: 'Bắt đầu giấc ngủ mới',
        ),
        SizedBox(height: 50.h),
        if (listSleeps.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: double.infinity),
              const AppText20(
                'Giấc ngủ gần nhất',
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20.h),
              Card(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText16(
                            'Đi ngủ: ${currentSleep!.startDateFormat!}',
                          ),
                          AppText16('Thức dậy: ${currentSleep.endDateFormat!}'),
                        ],
                      ),
                      const Spacer(),
                      AppText20(
                        textTotalDuration,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: ref.context,
                          isScrollControlled: false,
                          builder: (context) => _buildHistorySleep(listSleeps),
                        );
                      },
                      child: const AppText20('Xem thêm'))),
            ],
          ),
        SizedBox(height: 100.h),
      ],
    );
  }

  Widget _buildStopTracker(
      {required WidgetRef ref, required List<SleepEntity> listSleeps}) {
    SleepEntity currentSleep = listSleeps.first;
    int durationSlepNow =
        DateTime.now().difference(currentSleep.startTime!).inMinutes;
    String textCurrentDuration = 'Đã ngủ được: $durationSlepNow phút';
    if (durationSlepNow > 60) {
      textCurrentDuration = 'Đã ngủ được: ${durationSlepNow / 60} giờ';
    }
    return Column(
      children: [
        const SizedBox(width: double.infinity),
        AppText20('Giờ bắt đầu: ${currentSleep.startDateFormat}'),
        SizedBox(height: 15.h),
        AppText55(formatTime(DateTime.now())),
        SizedBox(height: 15.h),
        AppText20(
          textCurrentDuration,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 50.h),
        AppButton(
          ontap: () {
            ref.read(sleepProvider.notifier).stopSleep(endTime: DateTime.now());
          },
          width: 200,
          name: 'Đã thức dậy',
        ),
      ],
    );
  }

  Widget _buildHistorySleep(List<SleepEntity> listSleeps) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listSleeps.length,
        itemBuilder: (context, index) {
          final sleep = listSleeps[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            child: ListTile(
              title: Text(
                  "Ngày : ${sleep.startTime!.day} tháng ${sleep.startTime!.month}"),
              subtitle: Text(
                  "Bắt đầu: ${sleep.startDateFormat}\nKết thúc: ${sleep.endDateFormat}"),
              trailing: sleep.endTime != null
                  ? const Icon(Icons.check, color: Colors.green)
                  : const Icon(Icons.hourglass_empty, color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}

class SleepSetupDialogWidget extends ConsumerStatefulWidget {
  const SleepSetupDialogWidget({super.key});

  @override
  ConsumerState createState() => _SleepSetupDialogWidgetState();
}

class _SleepSetupDialogWidgetState
    extends ConsumerState<SleepSetupDialogWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _hoursController;
  double? hours;

  @override
  void initState() {
    super.initState();
    _hoursController = TextEditingController();
  }

  void init(TargetEntity? objTarget) {
    if (objTarget != null) {
      _hoursController.text = objTarget.target.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fetchTarget = ref.watch(sleepTargetProvider);
    final planBed = ref.watch(planBedProvider);

    return fetchTarget.when(
      data: (objTarget) {
        init(objTarget);
        return AlertDialog(
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 300.w),
                  const AppText24(
                    'Thiết lập',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.w),
                  AppTextFormField(
                    controller: _hoursController,
                    lable: 'Số giờ ngủ (giờ /ngày)',
                    validator: (value) {
                      hours = double.tryParse(value ?? '');
                      if (hours == null) {
                        return 'Hãy chỉ nhập số';
                      }
                      if (hours! < 5) {
                        return 'Đừng ngủ dưới 5 tiếng nhé!';
                      }
                      return null;
                    },
                    inputType: TextInputType.number,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const AppText16(
                        'Giờ nhắc ngủ',
                        fontWeight: FontWeight.bold,
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showTimePicker(planBed),
                        icon: const AppIcon(
                          path: ImageRes.icCalandar,
                          size: 19,
                        ),
                        label: Text(planBed.format(context)),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  AppButton(
                    width: 190.w,
                    ontap: () {
                      if (_formKey.currentState!.validate()) {
                        ref
                            .read(sleepTargetProvider.notifier)
                            .setTarget(hours ?? 8);
                        Navigator.pop(context);
                      }
                    },
                    name: 'Chốt luôn',
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (e, s) => const Center(child: Text('Error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showTimePicker(TimeOfDay planBed) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: planBed,
    );
    if (newTime != null) {
      ref.read(planBedProvider.notifier).setTime(newTime);
    }
  }
}
