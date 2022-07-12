import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/bloc/user/user_cubit.dart';
import 'package:letsworkout/bloc/user/user_state.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/enum/user_type.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/screen/calendar/calendar_screen.dart';
import 'package:letsworkout/screen/feed/feed_screen.dart';
import 'package:letsworkout/screen/search/search_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _friendSearchController = TextEditingController();
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _friendSearchController.dispose();
    super.dispose();
  }

  void onIndexChange(int index) {
    setState(() {
      _friendSearchController.text = "";
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBar(_index),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('프로필 변경'),
                onTap: () =>
                    Navigator.popAndPushNamed(context, Routes.profileScreen),
              ),
              ListTile(
                title: const Text('로그아웃'),
                onTap: () async {
                  AppBloc.userCubit.logout(context);
                },
              ),
              ListTile(
                title: const Text('고객 문의 & 기능건의'),
                onTap: () async {
                  Navigator.popAndPushNamed(
                      context, Routes.customerQuestionWriteScreen);
                },
              ),
              // 관리자만 열람 가능한 페이지
              if (AppBloc.userCubit.user?.userType == UserType.admin.index)
                ListTile(
                  title: const Text('건의함'),
                  onTap: () async {
                    Navigator.pushNamed(
                        context, Routes.customerQuestionViewScreen);
                  },
                ),
              ListTile(
                title: const Text('테스트 기능 동작'),
                onTap: () async {
                  print(await Permission.notification.request().isDenied);
                  print(await Permission.notification
                      .request()
                      .isPermanentlyDenied);
                  print(await Permission.notification.request().isLimited);
                  print(await Permission.notification.request().isRestricted);
                  print(await Permission.notification.request().isGranted);
                  // await FirebaseMessaging.instance.requestPermission();
                  // getFcmToken();
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _index,
          onTap: onIndexChange,
          selectedColorOpacity: 0,
          margin: const EdgeInsets.all(0),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              title: const Text("운동하자!"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.search_outlined),
              activeIcon: const Icon(Icons.search),
              title: const Text("친구찾기"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.calendar_month_outlined),
              activeIcon: const Icon(Icons.calendar_month),
              title: const Text("기록"),
            ),
          ],
        ),
        body: Builder(builder: (context) {
          User user = AppBloc.userCubit.user!;
          switch (_index) {
            case 0:
              return FeedScreen(user: user);
            case 1:
              return const SearchScreen();
            case 2:
              return CalendarScreen(user: user);
            default:
              return Container();
          }
        }),
      ),
    );
  }

  PreferredSizeWidget? _appBar(int index) {
    // 친구찾기
    if (index == 1) {
      return AppBar(
        title: TextField(
          controller: _friendSearchController,
          maxLength: 100,
          maxLines: 1,
          onChanged: (text) => setState(() {}),
          onSubmitted: (word) {
            FocusScope.of(context).requestFocus(FocusNode());
            AppBloc.searchCubit.search(word);
          },
          decoration: InputDecoration(
            hintText: '태그 입력',
            counterText: "",
            suffixIcon: _friendSearchController.text.isNotEmpty
                ? const Icon(
                    Icons.cancel,
                    size: 20,
                    color: Colors.grey,
                  )
                : null,
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      );
    } else {
      return AppBar(
        title: BlocBuilder<UserCubit, UserState>(
          bloc: AppBloc.userCubit,
          builder: (context, state) {
            return Text(
              '${state.user!.name ?? state.user!.tag}아 운동하자!',
            );
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      );
    }
  }
}
