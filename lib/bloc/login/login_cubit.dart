import 'package:bloc/bloc.dart';
import 'package:letsworkout/bloc/app_bloc.dart';
import 'package:letsworkout/enum/login_provider.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/repository/user_repository.dart';
import 'package:letsworkout/util/app_util.dart';
import 'package:letsworkout/util/cubit_util.dart';
import 'package:letsworkout/util/widget_util.dart';

//***
//
//    로그인과 회원 가입을 담당하는 큐빗
//    나머지 유저 관련 큐빗은 userCubit으로 가시오.
//
// */
class LoginCubit extends Cubit<User> {
  LoginCubit() : super(User());

  final UserRepository _repository = UserRepository();

  void setUser(User newUser) {
    emit(newUser);
  }

  Future<bool> snsLogin(LoginProvider provider) async {
    String? email = await _snsAuth(provider);
    User? user = await _getUserByEmail(email, provider);

    if (user == null) {
      // 회원가입에 쓸 로그인 정보 저장
      AppBloc.loginCubit.setUser(AppBloc.loginCubit.state.copyWith(
        email: email,
        provider: provider.name,
      ));
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
            try {
              kakao.OAuthToken token =
                  await kakao.UserApi.instance.loginWithKakaoAccount();
              kakao.AccessTokenInfo tokenInfo =
                  await kakao.UserApi.instance.accessTokenInfo();
              print(kakao.UserApi.instance);

              kakao.User user = await kakao.UserApi.instance.me();
              email = user.kakaoAccount!.email!;
            } catch (e) {
              // 사용자가 도중에 취소한 경우
              snack('로그인 시도를 취소하였습니다.');
              throw Exception('로그인 시도 취소');
            }
          }
        } else {
          snack('카카오톡이 설치되어 있지 않습니다.');
        }
        break;
    }

    return email;
  }

  Future<User?> _getUserByEmail(String? email, LoginProvider provider) async {
    if (email == null) {
      return null;
    }

    // user데이터가 있는지 통신
    User? user = await _repository.getUserByEmailProvider(email, provider.name);
    return user;
  }

  Future<bool> registUser({required String tag}) async {
    try {
      User? user = AppBloc.userCubit.user;
      if (user == null) {
        snack("처음부터 다시 시도해 주십시오.");
        return false;
      }

      user = user.copyWith(
        tag: tag,
        fcmToken: await getFcmToken(),
      );
      bool? isExistTag = await _repository.isExistTag(user.tag!);

      if (isExistTag == false) {
        snack("이미 존재하는 태그이름입니다.\n다른 이름을 사용하세요.");
        return false;
      } else if (isExistTag == true) {
        user = await _repository.registUser(user);
        await AppBloc.userCubit.setUser(user!);
        return true;
      }
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> autoLogin(User requestUser) async {
    try {
      loadingShow();
      User? user = await _repository.login(requestUser.copyWith(
        fcmToken: await getFcmToken(),
      ));
      if (user == null) {
        return false;
      }

      AppBloc.userCubit.setUser(user);
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      loadingHide();
    }
  }
}
