sealed class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class Loading extends PhoneAuthState {}

class ErrorOccurred extends PhoneAuthState {
  String errorMsg;

  ErrorOccurred({required this.errorMsg});
}

class PhoneNumberSubmited extends PhoneAuthState {}

class PhoneOtpVerified extends PhoneAuthState {}
