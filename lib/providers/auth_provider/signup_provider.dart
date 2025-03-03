import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/verify_otp.dart';
import 'package:riverpod/riverpod.dart';

import '../../services/loading_state.dart';



final signupProvider = StateNotifierProvider<SignupNotifier,LoadingState>((ref){
  return SignupNotifier();
});

class SignupNotifier extends StateNotifier<LoadingState>{

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.dispose();
    emailController.dispose();
    confirmPassword.dispose();
  }
  SignupNotifier():super(LoadingState(isLoading: false));
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  Future<void> signupUser({required BuildContext context})async{
    try{
      state = state.copyWith(isLoading: true);
      print('emailController : ${emailController.text}');
      await supaBase.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
      ).timeout(const Duration(seconds: 5));
      state = state.copyWith(isLoading: false);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> VerifyOtp(email: emailController.text.trim(),magicLink: false,updatePassword: false,))).then((value){
        confirmPassword.clear();
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

}




