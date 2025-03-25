import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/core/models/user_model/user_model.dart';
import 'package:ripverpod_supabase/services/net_work_excptions.dart';
import 'package:ripverpod_supabase/services/supaBase_services.dart';
import 'package:ripverpod_supabase/views/home/home_screen.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/forgot_password.dart';
import 'package:riverpod/riverpod.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../views/bottom_nav/bottom_nav_screen.dart';
import '../../views/screens/auth_screens/update_password.dart';



final otpProvider = StateNotifierProvider<VerifyNotifier,VerifyState>((ref){
  return VerifyNotifier(ref);
});

class VerifyNotifier extends StateNotifier<VerifyState> {
  final Ref ref;
  VerifyNotifier(this.ref) : super(VerifyState(isLoading: false, resendLoading: false, secondsRemaining: 0,forgotLoading: false));

  TextEditingController otpController = TextEditingController();
  Timer? _timer;

  String getTitle(OtpType otp) {
    switch (otp) {
      case OtpType.signup:
        return 'Signup';
      case OtpType.magiclink:
        return 'Login';
      case OtpType.emailChange:
        return 'Confirm Email';
      case OtpType.recovery:
        return 'Confirm Password';
      case OtpType.phoneChange:
        return 'Confirm Phone';
      default:
        return 'Confirm'; // Just in case, though it's not needed for bool
    }
  }



  Future<void> confirmOtp({
    required String email,
    required BuildContext context,
    required OtpType otpType,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      await supaBase.auth.verifyOTP(
        email: email,
        token: otpController.text.trim(),
        type: otpType,
      ).timeout(const Duration(seconds: 5));
      switch (otpType) {
        case OtpType.signup:
          saveUserData(context: context).then((value){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavScreen()));
          });
          break;
        case OtpType.magiclink:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const BottomNavScreen()));
          break;
        case OtpType.recovery:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ForgotPassword()));
          break;
        case OtpType.emailChange:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavScreen())).then((v) async {
            updateEmail(context: context,newEmail: email);
          });
          break;
        case OtpType.email:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UpdatePassword()));
          break;
        default:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
      otpController.clear();
      state = state.copyWith(isLoading: false);
    } catch (error) {
      ExceptionHandler.handle(error, context);
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> resendOtp({required String email, required BuildContext context,required OtpType otpType}) async {
    if (state.secondsRemaining > 0) return;
    try {
      state = state.copyWith(resendLoading: true);
      await supaBase.auth.resend(
        email: email,
        type: otpType,
      ).timeout(const Duration(seconds: 5));
      otpController.clear();
      startTimer();
      state = state.copyWith(resendLoading: false);
    } catch (error) {
      ExceptionHandler.handle(error, context);
      state = state.copyWith(resendLoading: false);
      rethrow;
    }
  }

  void startTimer() {
    state = state.copyWith(secondsRemaining: 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining > 0) {
        state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> saveUserData({required BuildContext context}) async {
    try {
      var userData = UserModel(
        id: id,
        name: name,
        email: email,
        userName: userName,
        phone: '',
        address: '',
        bio: '',
        imageUrl: '',
        isProfileCompleted: false,
        profilePoints: 35,
      );
      await SupaBaseServices.insertData<Map<String, dynamic>>(tableName: userTable, data: userData.toJson(),
          context: context
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }


  Future<void> updateEmail ({required BuildContext context,required String newEmail})async{
    try{
      SupaBaseServices.updateData(tableName: userTable, updatedData: {'email': newEmail}, column: 'user_id', value: supaBase.auth.currentUser!.id, context: context);
    }catch(e){
      rethrow;
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}


class VerifyState {
  final bool isLoading;
  final bool resendLoading;
  final int secondsRemaining;
  final bool forgotLoading ;
  VerifyState({
    required this.isLoading,
    required this.resendLoading,
    required this.secondsRemaining,
    required this.forgotLoading,
  });

  VerifyState copyWith({bool? isLoading, bool? resendLoading, int? secondsRemaining,bool? forgotLoading}) {
    return VerifyState(
      isLoading: isLoading ?? this.isLoading,
      resendLoading: resendLoading ?? this.resendLoading,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      forgotLoading: forgotLoading ?? this.forgotLoading,
    );
  }
}


