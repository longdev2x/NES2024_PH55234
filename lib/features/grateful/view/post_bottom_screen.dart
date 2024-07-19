import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/utils/app_constants.dart';
import 'package:nes24_ph55234/data/models/post_entity.dart';

class PostBottomScreen extends StatelessWidget {
  const PostBottomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
            title: const AppText16('Điều biết ơn hôm nay'),
            centerTitle: true,
            actions: [
              ElevatedButton(
                onPressed: () {},
                child: const AppText20('Lưu'),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppConstants.marginHori),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: DropdownButton<String>(
                    iconSize: 30.r,
                    value: PostLimit.values.first.name,
                    items: PostLimit.values
                        .map((e) => DropdownMenuItem(
                            value: e.name, child: Text(e == PostLimit.private ? 'Chỉ mình tôi' : 'Công khai')))
                        .toList(),
                    onChanged: (value) {

                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
