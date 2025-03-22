import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'package:ripverpod_supabase/services/supaBase_services.dart';

final userProfileProvider = StreamProvider.autoDispose((ref) {
  final userId = supaBase.auth.currentUser!.id;
  return SupaBaseServices.getUserData(userId: userId);
});