import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/enum/login_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Future<void> _login(LoginProvider provider) async {
    bool isRegisterd = await AppBloc.loginCubit.snsLogin(provider);

    // 메인화면으로 이동
    if (isRegisterd) {
    }

    // 회원가입 (약관동의 화면으로 이동)
    else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Center(
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text('한결아 운동하자'),
              ),
            ),
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () => _login(LoginProvider.kakao),
                  child: Container(
                    height: 60,
                    width: 250,
                    color: Colors.yellow,
                    child: const Text('카카오톡으로 로그인'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
