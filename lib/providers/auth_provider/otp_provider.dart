import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/views/home/home_screen.dart';
import 'package:riverpod/riverpod.dart';
import 'package:supabase/supabase.dart';

import '../../views/screens/auth_screens/update_password.dart';



final otpProvider = StateNotifierProvider<VerifyNotifier,VerifyState>((ref){
  return VerifyNotifier();
});

class VerifyNotifier extends StateNotifier<VerifyState> {
  VerifyNotifier() : super(VerifyState(isLoading: false, resendLoading: false, secondsRemaining: 0,forgotLoading: false));


  TextEditingController otpController = TextEditingController();
  Timer? _timer;
  Future<void> confirmOtp({required String email, required BuildContext context,required bool magicLink,required bool updatePassword}) async {
    try {
      print('email : ${email}');
      state = state.copyWith(isLoading: true);
      await supaBase.auth.verifyOTP(
        email: email,
        token: otpController.text.trim(),
        type: magicLink == false ? OtpType.signup : OtpType.magiclink,
      ).timeout(const Duration(seconds: 5));
      if(updatePassword == true){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UpdatePassword()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
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
  Future<void> resendOtp({required String email, required BuildContext context}) async {
    if (state.secondsRemaining > 0) return;
    try {
      state = state.copyWith(resendLoading: true);
      await supaBase.auth.resend(
        email: email,
        type: OtpType.signup,
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


