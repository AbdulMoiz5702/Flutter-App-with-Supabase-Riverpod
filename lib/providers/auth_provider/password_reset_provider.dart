import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/services/loading_state.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/login_screen.dart';
import 'package:supabase/supabase.dart';


final resetProvider = StateNotifierProvider<ResetNotifier , GenericLoadingState>((red){
  return ResetNotifier();
});


class ResetNotifier extends StateNotifier<GenericLoadingState>{

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    updatePasswordController.dispose();
    updateEmailController.dispose();
  }

  ResetNotifier() :super(GenericLoadingState(isLoading: false));

   TextEditingController updatePasswordController = TextEditingController();
   TextEditingController updateEmailController = TextEditingController();


  Future<void> updatePassword ({required BuildContext context})async{
    try{
      state = state.copyWith(isLoading: true);
      await supaBase.auth.updateUser(
        UserAttributes(
          password:updatePasswordController.text.trim()
        )
      );
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false,);
      updatePasswordController.clear();
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

   Future<void> updateEmail ()async{
     try{
       state = state.copyWith(isLoading: true);
       await supaBase.auth.updateUser(
           UserAttributes(
               password:updateEmailController.text.trim()
           )
       );
       updateEmailController.clear();
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


}