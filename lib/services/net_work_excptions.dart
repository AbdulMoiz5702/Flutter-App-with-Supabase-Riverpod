
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/utils/snack_bar.dart';
import 'app_exceptions.dart';


class TimeoutExceptionCustom extends AppException {
  TimeoutExceptionCustom() : super("⏳ Request timeout. Please try again later.");
}


class NoInternetException extends AppException {
  NoInternetException() : super("🌐 No internet connection. Please check your network.");
}


class ServerException extends AppException {
  ServerException() : super("❌ Server error. Please try again later.");
}


class UnknownException extends AppException {
  UnknownException(dynamic error) : super("❌ Unexpected error: $error");
}


class ExceptionHandler {

  static void handle(dynamic error, context) {
    String errorMessage = getMessage(error);
    debugPrint("⚠️ Exception Caught: $errorMessage");
    SnackBarClass.errorSnackBar(context: context, message: errorMessage);
  }

  static String getMessage(dynamic error) {
    if (error is TimeoutException) {
      return TimeoutExceptionCustom().message;
    } else if (error is SocketException || error.toString().contains('SocketException')) {
      return NoInternetException().message;
    } else if (error is HttpException) {
      return ServerException().message;
    } else {
      return UnknownException(error).message;
    }
  }
}


