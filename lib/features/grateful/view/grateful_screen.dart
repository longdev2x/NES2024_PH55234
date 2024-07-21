import 'package:flutter/material.dart';
import 'package:nes24_ph55234/common/components/app_global_app_bar.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/features/grateful/view/post_bottom_screen.dart';

class GratefulScreen extends StatelessWidget {
  const GratefulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appGlobalAppBar('Nhật ký biết ơn', actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutesNames.search);
            },
            icon: const Icon(Icons.search)),
      ]),
      body: Column(
        children: [
          Center(
            child: FloatingActionButton(
              child: const Text('POST'),
              onPressed: () => showModalBottomSheet(
                context: context,
                useSafeArea: false,
                isScrollControlled: true,
                builder: (ctx) => const PostBottomScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
