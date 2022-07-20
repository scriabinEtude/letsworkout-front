import 'package:flutter/material.dart';
import 'package:letsworkout/screen/calendar/calendar_detail_screen.dart';
import 'package:letsworkout/screen/calendar/calendar_detail_screen_args.dart';
import 'package:letsworkout/screen/calendar/calendar_screen.dart';
import 'package:letsworkout/screen/calendar/calendar_screen_args.dart';
import 'package:letsworkout/screen/customer/customer_question_view_screen.dart';
import 'package:letsworkout/screen/customer/customer_question_wirte_screen.dart';
import 'package:letsworkout/screen/diet/diet_write_screen.dart';
import 'package:letsworkout/screen/feed/feed_detail_screen.dart';
import 'package:letsworkout/screen/feed/feed_detail_screen_args.dart';
import 'package:letsworkout/screen/follow/follow_list_screen.dart';
import 'package:letsworkout/screen/follow/follow_list_screen_args.dart';
import 'package:letsworkout/screen/home_screen.dart';
import 'package:letsworkout/screen/login/register/agreement_screen.dart';
import 'package:letsworkout/screen/login/login_screen.dart';
import 'package:letsworkout/screen/login/register/regist_name_screen.dart';
import 'package:letsworkout/screen/login/register/regist_tag_screen.dart';
import 'package:letsworkout/screen/profile/profile_screen.dart';
import 'package:letsworkout/screen/splash_screen.dart';
import 'package:letsworkout/screen/workout/workout_start_screen.dart';

class Routes {
  // home
  static const String splashScreen = "/";
  static const String homeScreen = "/home";

  //login
  static const String loginScreen = "/login";
  static const String agreementScreen = "/login/regist/agreement";
  static const String registNameScreen = "login/regist/name";
  static const String registTagScreen = "/login/regist/tag";

  // user
  static const String profileScreen = "/profile";

  // workout
  static const String workoutStartScreen = "/workout/start";

  // diet
  static const String dietWriteScreen = "/diet/write";

  // feed
  static const String feedDetailScreen = "/feed/detail";

  // calendar
  static const String calendarScreen = "/calendar";
  static const String calendarDetailScreen = "/calendar/detail";
  static const String followListScreen = "/follow/list";

  // customer
  static const String customerQuestionWriteScreen = "/customer/question/write";
  static const String customerQuestionViewScreen = "/customer/question/view";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: splashScreen),
            builder: (BuildContext context) {
              return const SplashScreen();
            });
      case loginScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: loginScreen),
            builder: (BuildContext context) {
              return const LoginScreen();
            });
      case agreementScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: agreementScreen),
            builder: (BuildContext context) {
              return const AgreementScreen();
            });

      case registNameScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: registNameScreen),
            builder: (BuildContext context) {
              return const RegistNameScreen();
            });
      case registTagScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: registTagScreen),
            builder: (BuildContext context) {
              return const RegistTagScreen();
            });
      case homeScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: homeScreen),
            builder: (BuildContext context) {
              return const HomeScreen();
            });
      case workoutStartScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: workoutStartScreen),
            builder: (BuildContext context) {
              return const WorkoutStartScreen();
            });
      case calendarScreen:
        final CalendarScreenArgs args =
            settings.arguments as CalendarScreenArgs;
        return MaterialPageRoute(
            settings: const RouteSettings(name: calendarScreen),
            builder: (BuildContext context) {
              return CalendarScreen(
                user: args.user,
              );
            });
      case calendarDetailScreen:
        final CalendarDetailScreenArgs args =
            settings.arguments as CalendarDetailScreenArgs;
        return MaterialPageRoute(
            settings: const RouteSettings(name: calendarDetailScreen),
            builder: (BuildContext context) {
              return CalendarDetailScreen(
                calendarCubit: args.calendarCubit,
                date: args.date,
              );
            });
      case followListScreen:
        final FollowListScreenArgs args =
            settings.arguments as FollowListScreenArgs;
        return MaterialPageRoute(
            settings: const RouteSettings(name: followListScreen),
            builder: (BuildContext context) {
              return FollowListScreen(
                followCubit: args.followCubit,
              );
            });

      case profileScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: profileScreen),
            builder: (BuildContext context) {
              return const ProfileScreen();
            });

      case dietWriteScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: dietWriteScreen),
            builder: (BuildContext context) {
              return const DietWriteScreen();
            });

      case feedDetailScreen:
        FeedDetailScreenArgs args = settings.arguments as FeedDetailScreenArgs;
        return MaterialPageRoute(
            settings: const RouteSettings(name: feedDetailScreen),
            builder: (BuildContext context) {
              return FeedDetailScreen(
                feedActive: args.feedActive,
              );
            });

      case customerQuestionWriteScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: customerQuestionWriteScreen),
            builder: (BuildContext context) {
              return const CustomerQuestionWirteScreen();
            });
      case customerQuestionViewScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: customerQuestionViewScreen),
            builder: (BuildContext context) {
              return const CustomerQuestionViewScreen();
            });

      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Not Found"),
              ),
              body: Center(
                child: Text('No path for ${settings.name}'),
              ),
            );
          },
        );
    }
  }

  ///Singleton factory
  static final Routes _instance = Routes._internal();

  factory Routes() {
    return _instance;
  }

  Routes._internal();
}
