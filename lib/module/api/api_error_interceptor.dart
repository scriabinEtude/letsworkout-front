import 'package:dio/dio.dart';
import 'package:letsworkout/bloc/app_bloc.dart';

class ApiErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.type == DioErrorType.connectTimeout) {
      AppBloc.appCubit.appSnackBar('서버가 지연되고 있습니다. 잠시만 기다려 주십시오');
    } else {
      AppBloc.appCubit.appSnackBar('서버 에러입니다. 잠시만 기다려 주십시오');
    }
    super.onError(err, handler);
  }
}
