import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:nes24_ph55234/common/components/app_button.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/components/app_text_form_field.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginHori, vertical: AppConstants.marginVeti - 5),
        child: SingleChildScrollView(
          child: listSleep.isEmpty ||
                  (listSleep.first.startTime != null &&
                      listSleep.first.endTime != null)
              ? _buildStartTracker(ref: ref, listSleeps: listSleep)
              : _buildStopTracker(ref: ref, listSleeps: listSleep),
        ),
      ),
    );
  }

  Widget _buildStartTracker({required WidgetRef ref, required List<SleepEntity> listSleeps}) {
  SleepEntity? currentSleep;
  int? totalSleep;
  String? textTotalDuration;
  if (listSleeps.isNotEmpty) {
    currentSleep = listSleeps.first;
    totalSleep = currentSleep.endTime!.difference(currentSleep.startTime!).inMinutes;
    textTotalDuration = totalSleep > 60
        ? 'Ngủ được: ${(totalSleep / 60).toStringAsFixed(1)} giờ'
        : 'Ngủ được: $totalSleep phút';
  }

  final fetchSleepTarget = ref.watch(sleepTargetProvider);
  final TimeOfDay timeTellSleep = ref.read(planBedProvider);

  return SingleChildScrollView(
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fetchSleepTarget.when(
            data: (target) => _buildTargetCard(target, timeTellSleep, context, ref),
            error: (e, s) => const Center(child: Text('Error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          SizedBox(height: 25.h),
          Center(
            child: AppButton(
              ontap: () {
                ref.read(sleepProvider.notifier).startSleep(startTime: DateTime.now());
              },
              width: 270,
              name: 'Bắt đầu giấc ngủ mới',
            ),
          ),
          if (listSleeps.isNotEmpty) ...[
            SizedBox(height: 25.h),
            const AppText20(
              'Giấc ngủ gần nhất',
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
            SizedBox(height: 10.h),
            _buildLastSleepCard(currentSleep!, textTotalDuration!),
            SizedBox(height: 20.h),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: ref.context,
                    builder: (context) => _buildHistorySleep(listSleeps),
                  );
                },
                icon: Icon(Icons.history, color: Colors.indigo[700]),
                label: AppText18(
                  'Xem lịch sử giấc ngủ',
                  color: Colors.indigo[700],
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.indigo[400]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                ),
              ),
            ),
          ],
          SizedBox(height: 100.h),
        ],
      ),
  );
}

Widget _buildTargetCard(TargetEntity? target, TimeOfDay timeTellSleep, BuildContext context, WidgetRef ref) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
    child: Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText20(
                    'Mục tiêu',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                  SizedBox(height: 5.h),
                  AppText24(
                    '${target?.target ?? 8.0} giờ',
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[700],
                  ),
                ],
              ),
              Icon(Icons.nightlight_round, size: 40.w, color: Colors.indigo[400]),
            ],
          ),
          SizedBox(height: 15.h),
          Divider(color: Colors.grey[300]),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText16(
                'Giờ nhắc ngủ',
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: AppText18(
                  timeTellSleep.format(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          AppOutlineButton(
            text: 'Thiết lập lại',
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => const SleepSetupDialogWidget(),
              );
            },
          ),
        ],
      ),
    ),
  );
}

Widget _buildLastSleepCard(SleepEntity currentSleep, String textTotalDuration) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
    child: Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimeColumn('Đi ngủ:', currentSleep.startDateFormat!),
              _buildTimeColumn('Thức dậy:', currentSleep.endDateFormat!),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: AppText20(
              textTotalDuration,
              fontWeight: FontWeight.w600,
              color: Colors.indigo[700],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildTimeColumn(String label, String time) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText16(label, color: Colors.grey[600]),
      SizedBox(height: 4.h),
      AppText18(time, fontWeight: FontWeight.w600, color: Colors.indigo[700]),
    ],
  );
}

  //Màn hình stop
  Widget _buildStopTracker(
      {required WidgetRef ref, required List<SleepEntity> listSleeps}) {
    SleepEntity currentSleep = listSleeps.first;
    int durationSlepNow =
        DateTime.now().difference(currentSleep.startTime!).inMinutes;
    String textCurrentDuration =
        'Đã ngủ được: ${durationSlepNow ~/ 60} giờ ${durationSlepNow % 60} phút';

    return Container(
      margin: EdgeInsets.only(top: 70.h),
      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo.shade800, Colors.indigo.shade500],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
              Icons.alarm, 'Giờ bắt đầu', currentSleep.startDateFormat ?? ''),
          SizedBox(height: 30.h),
          _buildCurrentTime(),
          SizedBox(height: 30.h),
          _buildDurationInfo(textCurrentDuration),
          SizedBox(height: 50.h),
          _buildWakeUpButton(ref),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        SizedBox(width: 10.w),
        AppText20(
          '$label: $value',
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildCurrentTime() {
    return Column(
      children: [
        const AppText20('Thời gian hiện tại', color: Colors.white70),
        SizedBox(height: 10.h),
        AppText55(
          formatTime(DateTime.now()),
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  Widget _buildDurationInfo(String textCurrentDuration) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: AppText20(
        textCurrentDuration,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildWakeUpButton(WidgetRef ref) {
    return AppButton(
      ontap: () {
        ref.read(sleepProvider.notifier).stopSleep(endTime: DateTime.now());
      },
      width: 170,
      name: 'Đã thức dậy',
      bgColor: Colors.white,
      textColor: Colors.indigo.shade800,
      radius: 30,
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
                        icon: const AppIconAsset(
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
