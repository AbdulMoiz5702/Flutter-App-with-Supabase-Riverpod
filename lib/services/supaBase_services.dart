
// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:ripverpod_supabase/conts/supabase_consts.dart';
import 'net_work_excptions.dart';



class SupaBaseServices {


  static getUserData({required String userId}){
    return supaBase.from(userTable).stream(primaryKey: ['user_id'])   ;//select('user_id,email,phone,name');
  }



  Future<void> insertData<T extends Map<String, dynamic>>({required String tableName, required T data,required BuildContext context}) async {
    try {
      await supaBase.from(tableName).insert(data).select().timeout(const Duration(seconds: 10));
    } catch (e) {
      throw ExceptionHandler.handle(e,context);
    }
  }



  Future<void> updateData<T>({required String tableName,required Map<String, dynamic> updatedData,required String column,required dynamic value,required BuildContext context}) async {
    try {
      await supaBase.from(tableName).update(updatedData).eq(column, value).select().timeout(const Duration(seconds: 10));
    } catch (e) {
      throw ExceptionHandler.handle(e,context);
    }
  }



  Future<void> deleteData({required String tableName,required String column,required dynamic value,required BuildContext context}) async {
    try {
      await supaBase.from(tableName).delete().eq(column, value).select().timeout(const Duration(seconds: 10));
    } catch (e) {
      throw ExceptionHandler.handle(e,context);
    }
  }



}