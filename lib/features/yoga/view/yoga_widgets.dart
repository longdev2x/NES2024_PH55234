import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/components/app_dialog.dart';
import 'package:nes24_ph55234/common/components/app_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/image_res.dart';

class YogaMenu extends StatelessWidget {
  final String name;
  final Function()? onTapMore;
  const YogaMenu({super.key, required this.name, this.onTapMore});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppText16(
          name,
          fontWeight: FontWeight.bold,
        ),
        GestureDetector(
          onTap: onTapMore,
          child: const AppText10('Xem hết', fontWeight: FontWeight.bold,),
        ),
      ],
    );
  }
}


class CourseItemGrid extends ConsumerWidget {
  const CourseItemGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listImage = [
      ImageRes.sleepBanner,
      ImageRes.bmiBanner,
      ImageRes.gratefulBanner,
      ImageRes.yogaBanner,
      ImageRes.stepCounterBanner,
      ImageRes.adviseBanner
    ];

    return GridView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: listImage.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (ctx, index) {
        return AppImageWithColor(
          width: 40,
          height: 40,
          onTap: () async {
            Navigator.of(context).pushNamed(AppRoutesNames.yogaDetail);
            AppToast.showToast("Vào màn hình detail");
          },
          imagePath: listImage[index],
          boxFit: BoxFit.fitWidth,
        );
      },
    );
  }
}
