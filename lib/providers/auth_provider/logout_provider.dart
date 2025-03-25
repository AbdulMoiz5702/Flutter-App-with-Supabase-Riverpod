import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/services/net_work_excptions.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/login_screen.dart';
import 'package:riverpod/riverpod.dart';
import 'package:supabase/supabase.dart';




final logoutProvider = StateNotifierProvider<LogoutNotifier,LogoutState>((ref){
  return LogoutNotifier();
});

class LogoutNotifier extends StateNotifier<LogoutState> {

  LogoutNotifier():super(LogoutState(isLogout: false,isDeleteAccount:false ));

  Future<void> logoutLocal({required BuildContext context,required SignOutScope scope}) async{
    try{
      state = state.copyWith(isLogout: true);
      await supaBase.auth.signOut(scope: scope).then((v){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const LoginScreen()), (route)=> false);
      });
      state = state.copyWith(isLogout: false);
    }catch(e){
      state = state.copyWith(isLogout: false);
      ExceptionHandler.handle(e, context);
    }
  }

  Future<void> deleteUserAccount({required BuildContext context}) async{
    try{
      state = state.copyWith(isDeleteAccount: true);
      await supaBase.auth.admin.deleteUser(supaBase.auth.currentUser!.id);
      state = state.copyWith(isDeleteAccount: false);
    }catch(e){
      state = state.copyWith(isDeleteAccount: false);
      ExceptionHandler.handle(e, context);
    }
  }
}

class LogoutState {
  final bool isLogout;
  final bool isDeleteAccount;
  LogoutState({required this.isLogout,required this.isDeleteAccount});
  LogoutState  copyWith({bool ? isLogout,bool ? isDeleteAccount}){
    return LogoutState(isLogout: isLogout ?? this.isLogout, isDeleteAccount: isDeleteAccount ?? this.isDeleteAccount);
  }
}