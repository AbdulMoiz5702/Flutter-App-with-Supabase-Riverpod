
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/views/home/home_screen.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/signup_screen.dart';

import '../../views/user_profile/user_profile_screen.dart';


final splashProvider = Provider((ref){
  return SplashNotifier();
});

class SplashNotifier {
  Future<void> checkUserStatus({required BuildContext context})async{
    if(supaBase.auth.currentUser != null){
      print('userId : ${supaBase.auth.currentUser!.id}');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const UserProfileScreen()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const SignupScreen()));
    }
  }


}