import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/services/net_work_excptions.dart';
import 'package:ripverpod_supabase/utils/snack_bar.dart';
import 'package:ripverpod_supabase/views/bottom_nav/bottom_nav_screen.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/verify_otp.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final resetProvider = StateNotifierProvider<ResetNotifier , ResetState>((red){
  return ResetNotifier();
});


class ResetNotifier extends StateNotifier<ResetState>{

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    updatePasswordController.dispose();
    updateEmailController.dispose();
    confirmUpdatePasswordController.dispose();
  }

  ResetNotifier() :super(ResetState(isLoading: false,password:'',isChangeEmail: false,isReAuth: false));
   TextEditingController updatePasswordController = TextEditingController();
   TextEditingController  confirmUpdatePasswordController= TextEditingController();
   TextEditingController updateEmailController = TextEditingController();

  updatePasswordStrength(){
    state = state.copyWith(password: updatePasswordController.text);
  }

  Future<void> updatePassword ({required BuildContext context})async{
    try{
      state = state.copyWith(isLoading: true);
      await supaBase.auth.updateUser(UserAttributes(password:updatePasswordController.text.trim())).timeout(const Duration(seconds: 10));
      SnackBarClass.successSnackBar(context: context, message: 'Reset Password Confirm has been sent');
      updatePasswordController.clear();
      state = state.copyWith(isLoading: false);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const BottomNavScreen()), (route)=> false);
    } catch (error) {
      state = state.copyWith(isLoading: false);
      ExceptionHandler.handle(error, context);
      rethrow;
    }
  }

  Future<void> reAuth({required BuildContext context,required OtpType otpType,required String email})async{
    try{
      state = state.copyWith(isReAuth: true);
      await supaBase.auth.reauthenticate().timeout(const Duration(seconds: 10));
      state = state.copyWith(isReAuth: false);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> VerifyOtp(email: email, otpType: otpType)));
    } catch (error) {
      state = state.copyWith(isReAuth: false);
      ExceptionHandler.handle(error, context);
      rethrow;
    }
  }



   Future<void> updateEmail ({required BuildContext context})async{
     try{
       state = state.copyWith(isChangeEmail: true);
       await supaBase.auth.updateUser(UserAttributes(email:updateEmailController.text.trim())).timeout(const Duration(seconds: 10));
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  VerifyOtp(email:updateEmailController.text.trim(),otpType: OtpType.emailChange,))).then((value){
         updateEmailController.clear();
       });
       SnackBarClass.successSnackBar(context: context, message: 'Confirm OTP email has been sent to Email');
       state = state.copyWith(isChangeEmail: false);
     } catch (error) {
       state = state.copyWith(isChangeEmail: false);
       ExceptionHandler.handle(error, context);
       rethrow;
     }
   }
}

class ResetState {
  final bool isLoading ;
  final String password ;
  final bool isChangeEmail;
  final bool isReAuth ;
  ResetState({required this.isLoading,required this.password,required this.isChangeEmail,required this.isReAuth});

  ResetState copyWith({bool ? isLoading,String ? password,bool ? isChangeEmail,bool ? isChangeRequestEmail,bool ? isReAuth}){
    return ResetState(isLoading: isLoading ?? this.isLoading,password: password ?? this.password ,isChangeEmail: isChangeEmail ?? this.isChangeEmail,isReAuth: isReAuth ?? this.isReAuth);
  }
}