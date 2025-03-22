import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/services/net_work_excptions.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/verify_otp.dart';
import 'package:riverpod/riverpod.dart';
import 'package:supabase/supabase.dart';




final signupProvider = StateNotifierProvider<SignupNotifier,SignupState>((ref){
  return SignupNotifier();
});

class SignupNotifier extends StateNotifier<SignupState>{

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    emailController.dispose();
    confirmPassword.dispose();
    nameController.dispose();
    passwordController.dispose();
  }
  SignupNotifier():super(SignupState(isLoading: false,password: ''));
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  updatePasswordStrength(){
    state = state.copyWith(password: passwordController.text);
  }


  Future<void> signupUser({required BuildContext context})async{
    try{
      state = state.copyWith(isLoading: true);
      await supaBase.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
      ).then((value) {
        name = nameController.text.trim();
        phone = phoneController.text.trim();
        email = emailController.text.trim();
        id = value.user!.id ;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> VerifyOtp(email: emailController.text.trim(),otpType: OtpType.signup,isLogin: false,))).then((value){
          emailController.clear();
          phoneController.clear();
          passwordController.clear();
          confirmPassword.clear();
          nameController.clear();
        });
      }).timeout(const Duration(seconds: 5));
      state = state.copyWith(isLoading: false);
    }catch(error,s){
      state = state.copyWith(isLoading: false);
      ExceptionHandler.handle(error, context);
      rethrow;
    }
  }


}

class SignupState {
  final bool isLoading ;
  final String password ;
  SignupState({required this.isLoading,required this.password});

  SignupState copyWith({bool ? isLoading,String ? password}){
    return SignupState(isLoading: isLoading ?? this.isLoading,password: password ?? this.password);
  }
}


