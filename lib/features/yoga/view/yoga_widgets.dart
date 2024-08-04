import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nes24_ph55234/common/components/app_icon_image.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/video_entity.dart';
import 'package:nes24_ph55234/features/yoga/controller/video_provider.dart';

class YogaMenu extends StatelessWidget {
  final String name;
  final void Function()? onTapMore;
  const YogaMenu({super.key, required this.name, this.onTapMore});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppText20(
          name,
          fontWeight: FontWeight.bold,
        ),
        GestureDetector(
          onTap: onTapMore,
          child: const AppText14('Xem hết', fontWeight: FontWeight.bold, color: Colors.blue,),
        ),
      ],
    );
  }
}


class CourseItemGrid extends ConsumerWidget {
  final List<VideoEntity> listVideo;
  const CourseItemGrid(this.listVideo, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String imageDefault = listVideo.isEmpty || listVideo[0].type == AppConstants.typeVideoYoga
    ? 'https://cdn.hellobacsi.com/wp-content/uploads/2019/07/ch%C3%B3.png'
    : 'https://cdn.hellobacsi.com/wp-content/uploads/2019/12/tu-the-ngoi-thien-e1576037454765.jpg?w=1200&q=75';

    return GridView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: listVideo.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (ctx, index) {
        return AppCachedNetworkImage(
          width: 40,
          height: 40,
          title: listVideo[index].title,
          onTap: () async {
            Navigator.of(context).pushNamed(AppRoutesNames.yogaDetail, arguments: listVideo[index]);
            ref.read(videoControlProvider.notifier).state = listVideo[index];
          },
          imagePath: listVideo[index].thumbnail ?? imageDefault,
          boxFit: BoxFit.fitWidth,
        );
      },
    );
  }
}
