import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/services/net_work_excptions.dart';
import 'package:ripverpod_supabase/views/bottom_nav/bottom_nav_screen.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/verify_otp.dart';
import 'package:riverpod/riverpod.dart';
import 'package:supabase/supabase.dart';



final loginProvider = StateNotifierProvider<LoginNotifier,LoginState>((ref){
  return LoginNotifier();
});

class LoginNotifier extends StateNotifier<LoginState>{

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    emailController.dispose();
  }
  LoginNotifier():super(LoginState(isLoading: false,forgotLoading: false,otpLoading: false));


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser({required BuildContext context})async{
    try{
      state = state.copyWith(isLoading: true);
      await supaBase.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      ).timeout(const Duration(seconds: 5));
      state = state.copyWith(isLoading: false);
      // ignore: use_build_context_synchronously
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BottomNavScreen())).then((value){
        passwordController.clear();
        emailController.clear();
      });
    }catch(error){
      state = state.copyWith(isLoading: false);
      ExceptionHandler.handle(error, context);
      rethrow;
    }
  }

  Future<void> forgotPassword({ required BuildContext context}) async {
    try {
      state = state.copyWith(forgotLoading: true);
      await supaBase.auth.resetPasswordForEmail(
          emailController.text,
      ).timeout(const Duration(seconds: 5));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  VerifyOtp(email:emailController.text.toString(),otpType: OtpType.recovery,))).then((value){
        emailController.clear();
      });
      state = state.copyWith(forgotLoading: false);
    }catch (error) {
      state = state.copyWith(forgotLoading: false);
      ExceptionHandler.handle(error, context);
      rethrow;
    }
  }

  Future<void> loginWithOtp({ required BuildContext context}) async {
    try {
      state = state.copyWith(otpLoading: true);
      await supaBase.auth.signInWithOtp(
          email: supaBase.auth.currentUser!.email,
          shouldCreateUser: false,
      ).timeout(const Duration(seconds: 5));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  VerifyOtp(email:supaBase.auth.currentUser!.email.toString(),otpType: OtpType.magiclink,)));
      state = state.copyWith(otpLoading: false);
    } catch (error) {
      state = state.copyWith(otpLoading: false);
      ExceptionHandler.handle(error, context);
      rethrow;
    }
  }

}

class LoginState {
  final bool isLoading;
  final bool forgotLoading ;
  final bool otpLoading ;
  LoginState({
    required this.isLoading,
    required this.forgotLoading,
    required this.otpLoading,
  });

  LoginState copyWith({bool? isLoading,bool? forgotLoading,bool ? otpLoading}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      forgotLoading: forgotLoading ?? this.forgotLoading,
      otpLoading: otpLoading ?? this.otpLoading,
    );
  }
}




