import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/core/user_model.dart';
import 'package:ripverpod_supabase/views/home/home_screen.dart';
import 'package:riverpod/riverpod.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../views/screens/auth_screens/update_password.dart';



final otpProvider = StateNotifierProvider<VerifyNotifier,VerifyState>((ref){
  return VerifyNotifier(ref);
});

class VerifyNotifier extends StateNotifier<VerifyState> {
  final Ref ref;
  VerifyNotifier(this.ref) : super(VerifyState(isLoading: false, resendLoading: false, secondsRemaining: 0,forgotLoading: false));



  TextEditingController otpController = TextEditingController();
  Timer? _timer;
  Future<void> confirmOtp({
    required String email,
    required BuildContext context,
    required OtpType otpType,
  }) async {
    try {
      print('Email: $email');
      state = state.copyWith(isLoading: true);

      await supaBase.auth.verifyOTP(
        email: email,
        token: otpController.text.trim(),
        type: otpType, // Directly pass the OTP type
      ).timeout(const Duration(seconds: 5));

      // Handle navigation based on OTP type
      switch (otpType) {
        case OtpType.signup:
          saveUserData().then((value){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          });
          break;
        case OtpType.magiclink:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          break;
        case OtpType.recovery:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const UpdatePassword()));
          break;

        case OtpType.emailChange:
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => const EmailChangeScreen()));
          break;

        case OtpType.phoneChange:
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => const PhoneChangeScreen()));
          break;

        default:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
      otpController.clear();
      state = state.copyWith(isLoading: false);
    } on TimeoutException {
      state = state.copyWith(isLoading: false);
    } on SocketException {
      state = state.copyWith(isLoading: false);
    } catch (error) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> resendOtp({required String email, required BuildContext context,required OtpType otpType}) async {
    if (state.secondsRemaining > 0) return;
    try {
      state = state.copyWith(resendLoading: true);
      await supaBase.auth.resend(
        email: email,
        type: otpType,
      ).timeout(const Duration(seconds: 5));
      otpController.clear();
      startTimer();
      state = state.copyWith(resendLoading: false);
    } on TimeoutException {
      state = state.copyWith(resendLoading: false);
    } on SocketException {
      state = state.copyWith(resendLoading: false);
    } catch (error) {
      state = state.copyWith(resendLoading: false);
      rethrow;
    }
  }





  void startTimer() {
    state = state.copyWith(secondsRemaining: 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining > 0) {
        state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> saveUserData ()async{
    try{
      var userData = UserModel(
        id:id,
        name:name,
        email:email,
        phone:phone,
        address: 'test',
      );
      var data = supaBase.from(userTable);
      await data.insert(userData).select();
    }catch(e){
      print(e);
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}


class VerifyState {
  final bool isLoading;
  final bool resendLoading;
  final int secondsRemaining;
  final bool forgotLoading ;
  VerifyState({
    required this.isLoading,
    required this.resendLoading,
    required this.secondsRemaining,
    required this.forgotLoading,
  });

  VerifyState copyWith({bool? isLoading, bool? resendLoading, int? secondsRemaining,bool? forgotLoading}) {
    return VerifyState(
      isLoading: isLoading ?? this.isLoading,
      resendLoading: resendLoading ?? this.resendLoading,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      forgotLoading: forgotLoading ?? this.forgotLoading,
    );
  }
}


