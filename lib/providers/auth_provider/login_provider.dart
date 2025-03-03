import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/views/home/home_screen.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/verify_otp.dart';
import 'package:riverpod/riverpod.dart';
import 'package:supabase/supabase.dart';

import '../../services/loading_state.dart';



final loginProvider = StateNotifierProvider<LoginNotifier,LoginState>((ref){
  return LoginNotifier();
});

class LoginNotifier extends StateNotifier<LoginState>{

  @override
  void dispose() {
    // TODO: implement dispose
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen())).then((value){
        passwordController.clear();
        emailController.clear();
      });
    }on TimeoutException{
      state = state.copyWith(isLoading: false);
    } on SocketException {
      state = state.copyWith(isLoading: false);
    }catch(error){
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> forgotPassword({ required BuildContext context}) async {
    try {
      state = state.copyWith(forgotLoading: true);
      await supaBase.auth.resetPasswordForEmail(
          emailController.text
      ).timeout(const Duration(seconds: 5));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  VerifyOtp(email:emailController.text.toString(),magicLink: true,updatePassword: true,)));
      state = state.copyWith(forgotLoading: false);
      emailController.clear();
    } on TimeoutException {
      state = state.copyWith(forgotLoading: false);
    } on SocketException {
      state = state.copyWith(forgotLoading: false);
    } catch (error) {
      state = state.copyWith(forgotLoading: false);
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  VerifyOtp(email:supaBase.auth.currentUser!.email.toString(),magicLink: true,updatePassword: false,)));
      state = state.copyWith(otpLoading: false);
    } on TimeoutException {
      state = state.copyWith(otpLoading: false);
    } on SocketException {
      state = state.copyWith(otpLoading: false);
    } catch (error) {
      state = state.copyWith(otpLoading: false);
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




