import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nes24_ph55234/common/components/app_search_bar.dart';
import 'package:nes24_ph55234/common/components/app_text.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/features/friend/view/chat_screen.dart';
import 'package:nes24_ph55234/features/friend/view/friend_post_screen.dart';
import 'package:nes24_ph55234/features/friend/view/friend_screen.dart';

class MainFriendScreen extends ConsumerStatefulWidget {
  const MainFriendScreen({super.key});

  @override
  ConsumerState createState() => _MainFriendScreenState();
}

class _MainFriendScreenState extends ConsumerState<MainFriendScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SafeArea(child: SizedBox(
              )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: AppSearchBar(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutesNames.friendSearch);
                    },
                    hintText: 'Tìm bạn bè',
                    readOnly: true,
                    haveIcon: false,
                    width: 355,
                  ),
                ),
                SizedBox(height: 10.h),
              TabBar(
                controller: _tabController,
                tabs: const [
                  AppText16('Bạn bè'),
                  AppText16('Bài viết'),
                  AppText16('Trò chuyện'),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(controller: _tabController, children: const [
          FriendScreen(),
          FriendPostScreen(),
          ChatScreen(),
        ]),
      );
  }
}
