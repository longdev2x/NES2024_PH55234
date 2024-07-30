import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nes24_ph55234/common/routes/app_routes_names.dart';
import 'package:nes24_ph55234/features/advise/view/expert/expert_advise_session_screen.dart';
import 'package:nes24_ph55234/features/advise/view/user/user_advise_session_screen.dart';
import 'package:nes24_ph55234/features/application/view/application.dart';
import 'package:nes24_ph55234/features/auth/view/auth_screen.dart';
import 'package:nes24_ph55234/features/friend/view/friend_profile_screen.dart';
import 'package:nes24_ph55234/features/friend/view/friend_search_screen.dart';
import 'package:nes24_ph55234/features/friend/view/message_screen.dart';
import 'package:nes24_ph55234/features/grateful/view/grateful_screen.dart';
import 'package:nes24_ph55234/features/onboarding/view/onboarding.dart';
import 'package:nes24_ph55234/features/profile/view/BMI/bmi_navigate.dart';
import 'package:nes24_ph55234/features/profile/view/profile/edit_profile_screen.dart';
import 'package:nes24_ph55234/features/profile/view/profile/profile_screen.dart';
import 'package:nes24_ph55234/features/search/view/search_screen.dart';
import 'package:nes24_ph55234/features/sleep/view/sleep_screen.dart';
import 'package:nes24_ph55234/features/step/view/history_step_counter_screen.dart';
import 'package:nes24_ph55234/features/step/view/main_tab_step.dart';
import 'package:nes24_ph55234/features/yoga/view/yoga_detail_screen.dart';
import 'package:nes24_ph55234/features/yoga/view/yoga_screen.dart';
import 'package:nes24_ph55234/global.dart';

class AppRoutes {
  static List<RouteEntity> routes() {
    return [
      RouteEntity(
        path: AppRoutesNames.welcome,
        page: OnboardingScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.auth,
        page: AuthScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.application,
        page: ApplicationScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.search,
        page: SearchScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.steps,
        page: StepMainTab(),
      ),
      const RouteEntity(
        path: AppRoutesNames.yoga,
        page: YogaScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.historyStep,
        page: HistoryStepCounterScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.yogaDetail,
        page: YogaDetailScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.grateful,
        page: GratefulScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.bmi,
        page: BMINavigate(),
      ),
      const RouteEntity(
        path: AppRoutesNames.profile,
        page: ProfileScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.editProfile,
        page: EditProfileScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.friendSearch,
        page: FriendSearchScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.friendProfile,
        page: FriendProfileScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.messageScreen,
        page: MessageScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.adviseUser,
        page: UserAdviseSessionScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.adviseExpext,
        page: ExpertAdviseSessionScreen(),
      ),
      const RouteEntity(
        path: AppRoutesNames.sleep,
        page: SleepScreen(),
      ),
    ];
  }

  static MaterialPageRoute generateRoutSettings(RouteSettings settings) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    var result =
        routes().where((element) => element.path == settings.name).toList();

    bool deviceFirstTime = Global.storageService.getDeviceFirstOpen();
    bool isLoggedIn = firebaseAuth.currentUser != null;

    if (result[0].path == AppRoutesNames.welcome) {
      if (deviceFirstTime) {
        return MaterialPageRoute(builder: (ctx) => OnboardingScreen());
      }
      if (isLoggedIn) {
        return MaterialPageRoute(
          builder: (ctx) => const ApplicationScreen(),
          settings: settings,
        );
      }
      return MaterialPageRoute(
        builder: (ctx) => const AuthScreen(),
        settings: settings,
      );
    } else {
      return MaterialPageRoute(
        builder: (ctx) => result[0].page,
        settings: settings,
      );
    }
  }
}

class RouteEntity {
  const RouteEntity({
    required this.path,
    required this.page,
  });
  final String path;
  final Widget page;
}
