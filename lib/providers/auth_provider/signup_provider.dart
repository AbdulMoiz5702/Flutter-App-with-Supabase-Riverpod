import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/services/net_work_excptions.dart';
import 'package:ripverpod_supabase/services/supaBase_services.dart';
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
    userNameSubscription?.cancel();
    userNameController.dispose();
  }
  SignupNotifier():super(SignupState(isLoading: false,password: '',checkUserName: false));

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  StreamSubscription<List<Map<String, dynamic>>>? userNameSubscription;


  updatePasswordStrength(){
    state = state.copyWith(password: passwordController.text);
  }

  void checkUserNameAvailability({required BuildContext context}) {
    userNameSubscription?.cancel();
    String currentUserName = userNameController.text.trim();
    userNameSubscription = SupaBaseServices.getUserNameStream(userName: currentUserName).listen((data) {
      bool isAvailable = data.isEmpty;
      state = state.copyWith(checkUserName: isAvailable);
    },onError: (error) {
     ExceptionHandler.handle(error, context);
    });
  }



  Future<void> signupUser({required BuildContext context})async{
    try{
      state = state.copyWith(isLoading: true);
      await supaBase.auth.signUp(
        email: emailController.text,
        password: passwordController.text,
      ).then((value) {
        name = nameController.text.trim();
        userName = userNameController.text.trim();
        email = emailController.text.trim();
        id = value.user!.id ;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> VerifyOtp(email: emailController.text.trim(),otpType: OtpType.signup,))).then((value){
          emailController.clear();
          userNameController.clear();
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
  final bool checkUserName;
  SignupState({required this.isLoading,required this.password,required this.checkUserName,});

  SignupState copyWith({bool ? isLoading,String ? password,bool ? checkUserName}){
    return SignupState(isLoading: isLoading ?? this.isLoading,password: password ?? this.password,checkUserName: checkUserName ?? this.checkUserName);
  }
}


