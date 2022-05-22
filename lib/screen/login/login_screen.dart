import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/enum/login_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Future<void> _login(LoginProvider provider) async {
    AppBloc.loginCubit.snsLogin(provider);
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
                  onTap: () async {
                    //TODO ios에서도 가능하게 해야함
                  },
                  child: Container(
                    height: 60,
                    width: 250,
                    color: Colors.yellow,
                    child: Text('카카오톡으로 로그인'),
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
