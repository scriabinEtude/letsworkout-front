// ignore_for_file: constant_identifier_names

enum FcmCode {
  FCM_CODE_WORKOUT(100, "100"),
  FCM_CODE_WORKOUT_DONE(101, "101"),
  FCM_CODE_WORKOUT_DELETE(102, "102");

  final int code;
  final String codeString;

  const FcmCode(this.code, this.codeString);

  static final Map<dynamic, FcmCode> fcmCodeMap = {
    ...{for (FcmCode code in FcmCode.values) code.code: code},
    ...{for (FcmCode code in FcmCode.values) code.codeString: code},
  };
}
