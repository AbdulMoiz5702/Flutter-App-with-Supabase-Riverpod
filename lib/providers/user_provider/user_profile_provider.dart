import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/services/net_work_excptions.dart';
import '../../services/supaBase_services.dart';


final userProfileProvider = StreamProvider.autoDispose((ref) {
  final userId = supaBase.auth.currentUser!.id;
  return SupaBaseServices.getUserData(userId: userId);
});



final userProfileUpdate = StateNotifierProvider<ProfileUpdateNotifier,ProfileUpdateState>((ref){
    return ProfileUpdateNotifier();
});




class ProfileUpdateNotifier extends StateNotifier<ProfileUpdateState> {
  ProfileUpdateNotifier(): super(ProfileUpdateState(isLoading: false,isSecondLoading: false,checkUserName: false));

  @override
  void dispose() {
    address.dispose();
    bio.dispose();
    phone.dispose();
    name.dispose();
    userName.dispose();
    userNameSubscription?.cancel();
    super.dispose();
  }

  TextEditingController address = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController userName = TextEditingController();
  StreamSubscription<List<Map<String, dynamic>>>? userNameSubscription;

  void checkUserNameAvailability({required BuildContext context}) {
    userNameSubscription?.cancel();
    String currentUserName = userName.text.trim();
    userNameSubscription = SupaBaseServices.getUserNameStream(userName: currentUserName).listen((data) {
      bool isAvailable = data.isEmpty;
      state = state.copyWith(checkUserName: isAvailable);
    },onError: (error) {
      ExceptionHandler.handle(error, context);
    });
  }


  Future<void> updateUserDetails({required BuildContext context}) async{
    try{
      state = state.copyWith(isSecondLoading: true);
      SupaBaseServices.updateData(tableName: userTable, updatedData: {
        'address':address.text.trim(),
        'bio':bio.text.trim(),
        'phone':phone.text.trim(),
      }, column: 'user_id', value: supaBase.auth.currentUser!.id, context: context).then((v){
        Navigator.pop(context);
        address.clear();
        phone.clear();
        bio.clear();
      });
      state = state.copyWith(isSecondLoading: false);
    }catch(error){
      state = state.copyWith(isSecondLoading: false);
    }
  }

  Future<void> updateUserProfile({required BuildContext context}) async{
    try{
      state = state.copyWith(isLoading: true);
      SupaBaseServices.updateData(tableName: userTable, updatedData: {
        'userName':userName.text.trim(),
        'name':name.text.trim(),
      }, column: 'user_id', value: supaBase.auth.currentUser!.id, context: context).then((v){
        Navigator.pop(context);
        userName.clear();
        name.clear();
      });
      state = state.copyWith(isLoading: false);
    } catch(error){
      state = state.copyWith(isLoading: false);
    }
  }



}


class ProfileUpdateState {
  final bool isLoading;
  final bool isSecondLoading ;
  final bool checkUserName ;
  ProfileUpdateState({required this.isLoading,required this.isSecondLoading,required this.checkUserName});
  ProfileUpdateState copyWith({bool ?isLoading, bool ? isSecondLoading,bool ? checkUserName}){
    return ProfileUpdateState(isLoading: isLoading?? this.isLoading, isSecondLoading: isSecondLoading ?? this.isSecondLoading,checkUserName: checkUserName ?? this.checkUserName);
  }
}






