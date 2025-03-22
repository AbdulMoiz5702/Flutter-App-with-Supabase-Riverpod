





import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/services/loading_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String webClientId = '772296925521-ne85ijk3dm2lipevpe5a4tcd55pg1afp.apps.googleusercontent.com';

final linkIdentityProvider = StateNotifierProvider<LinkIdentityNotifier,GenericLoadingState>((ref){
  return LinkIdentityNotifier();
});


class LinkIdentityNotifier  extends StateNotifier<GenericLoadingState>{

  LinkIdentityNotifier(): super(GenericLoadingState(isLoading: false));


  final GoogleSignIn googleSignIn = GoogleSignIn(
    serverClientId: webClientId,
  );

  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true);
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // User canceled sign-in
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;
      if (idToken == null || accessToken == null) {
        throw Exception('Google authentication tokens not found.');
      }
      await linkGoogleIdentity(idToken, accessToken).timeout(const Duration(seconds: 20));
      state = state.copyWith(isLoading: false);
    } on TimeoutException{
      state = state.copyWith(isLoading: false);
    } on SocketException {
      state = state.copyWith(isLoading: false);
    } catch (e) {
      print("Error signing in with Google: $e");
      state = state.copyWith(isLoading: false);
      rethrow ;

    }
  }


  Future<void> linkGoogleIdentity(String idToken, String accessToken) async {
    try {
      if (supaBase.auth.currentUser == null) {
        throw Exception("User must be signed in before linking Google.");
      }
      await supaBase.auth.linkIdentity(OAuthProvider.google);
      print("Google account successfully linked to user.");
    } catch (e) {
      print("Failed to link Google account: $e");
    }
  }


}
