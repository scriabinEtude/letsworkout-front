import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:letsworkout/bloc/user/user_state.dart';
import 'package:letsworkout/config/constant.dart';
import 'package:letsworkout/config/preference.dart';
import 'package:letsworkout/config/route.dart';
import 'package:letsworkout/enum/bucket_path.dart';
import 'package:letsworkout/enum/loading_state.dart';
import 'package:letsworkout/model/signed_url.dart';
import 'package:letsworkout/model/user.dart';
import 'package:letsworkout/repository/app_repository.dart';
import 'package:letsworkout/repository/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState());

  final UserRepository _userRepository = UserRepository();

  void setLoading(LoadingState loading) {
    emit(state.copyWith(loading: loading));
  }

  User? loadInitialData() {
    User? user = Preferences.userGet();
    emit(state.copyWith(user: user));
    return user;
  }

  Future<void> setUser(User user) async {
    await Preferences.userSet(user);
    emit(state.copyWith(user: user));
  }

  //** 로그인된 유저를 지우고 스플래시로 이동 */
  Future<void> logout(BuildContext context) async {
    await Preferences.userInit();
    emit(state.userInit());
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.splashScreen, (_) => false);
  }

  Future<bool> _updateProfileImage({
    required bool isProfileImageUpdate,
    required dynamic image,
  }) async {
    try {
      if (!isProfileImageUpdate) return true;

      // 이미지 제거하는 경우
      if (image == null) {
        bool success =
            await _userRepository.deleteProfileImage(state.user!.userId!);
        if (success) {
          emit(state.copyWith(user: state.user!.deleteProfileImage()));
          return true;
        } else {
          return false;
        }
      }

      // 새로운 이미지 동록
      else {
        SignedUrl? signedUrl = await AppRepository.getSignedUrl(
          bucketPath: BucketPath.userProfile,
          filename: '${state.user!.userId}',
          image: image,
        );

        if (signedUrl == null) return false;

        // 업로드
        bool success = await AppRepository.s3upload(
          url: signedUrl,
          file: image,
        );

        if (success) {
          success = await _userRepository.updateProfileImage(
            state.user!.userId!,
            signedUrl.url,
          );
          if (success) {
            emit(state.copyWith(
              user: state.user!.copyWith(profileImage: signedUrl.url),
            ));
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateUser({
    required String name,
    required bool isProfileImageUpdate,
    required dynamic image,
  }) async {
    setLoading(LoadingState.loading);
    try {
      bool success = await _updateProfileImage(
        isProfileImageUpdate: isProfileImageUpdate,
        image: image,
      );

      if (success) {
        User user = state.user!.copyWith(name: name);
        if (await _userRepository.updateUser(user)) {
          await setUser(user);
        }
      }

      return success;
    } catch (e) {
      print(e);
      return false;
    } finally {
      setLoading(LoadingState.done);
    }
  }

  User? get user => state.user;
}
