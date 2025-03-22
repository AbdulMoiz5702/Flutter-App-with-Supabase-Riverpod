
import 'dart:io';
import 'dart:async';

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
  static AppException handle(dynamic error,context) {
    if (error is TimeoutException) {
      SnackBarClass.errorSnackBar(context: context, message: '⏳ Request timeout. Please try again later.');
      return TimeoutExceptionCustom();
    } else if (error is SocketException) {
      SnackBarClass.errorSnackBar(context: context, message: '🌐 No internet connection. Please check your network.');
      return NoInternetException();
    } else if (error is HttpException) {
      SnackBarClass.errorSnackBar(context: context, message: '❌ Server error. Please try again later.');
      return ServerException();
    } else {
      SnackBarClass.errorSnackBar(context: context, message: '❌ Unexpected error: $error');
      return UnknownException(error);
    }
  }
}
