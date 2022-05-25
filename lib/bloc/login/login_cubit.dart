import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/enum/login_provider.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/repository/user_repository.dart';

class LoginCubit extends Cubit<int> {
  LoginCubit() : super(0);

  final UserRepository _repository = UserRepository();

  Future<bool> snsLogin(LoginProvider provider) async {
    if (provider == LoginProvider.test) {
      AppBloc.userCubit
          .setUser(User(email: 'test@test.co.kr', provider: provider.name));
      return false;
    }

    String? email = await _snsAuth(provider);
    User? user = await _getUserByEmail(email);
    if (user == null) {
      return false;
    }

    // 유저정보 저장
    AppBloc.userCubit.setUser(user);
    return true;
  }

  Future<String?> _snsAuth(LoginProvider provider) async {
    String? email;

    // 인증 정보 얻어오기
    switch (provider) {
      case LoginProvider.kakao:
        if (await kakao.isKakaoTalkInstalled()) {
          try {
            // 카카오로 인증
            await kakao.UserApi.instance.loginWithKakaoTalk();
            kakao.User user = await kakao.UserApi.instance.me();

            email = user.kakaoAccount!.email!;
          } catch (e) {
            AppBloc.appCubit.appSnackBar('로그인에 실패하였습니다.');
          }
        } else {
          AppBloc.appCubit.appSnackBar('카카오톡이 설치되어 있지 않습니다.');
        }
        break;
      case LoginProvider.test:
        break;
    }

    return email;
  }

  Future<User?> _getUserByEmail(String? email) async {
    if (email == null) {
      return null;
    }

    // user데이터가 있는지 통신
    User? user = await _repository.getUserByEmail(email);
    return user;
  }

  Future<bool> registUser({required String tag}) async {
    User? user = AppBloc.userCubit.user;
    if (user == null) {
      AppBloc.appCubit.appSnackBar("처음부터 다시 시도해 주십시오.");
      return false;
    }

    user = user.copyWith(tag: tag);
    if (await _repository.registUser(user)) {
      await AppBloc.userCubit.setUser(user);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> autoLogin(User requestUser) async {
    User? user = await _repository.getUser(requestUser);
    if (user == null) {
      return false;
    }

    AppBloc.userCubit.setUser(user);
    return true;
  }
}
