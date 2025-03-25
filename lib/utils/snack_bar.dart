



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/conts/colors.dart';
import 'package:ripverpod_supabase/views/widgets/text_widgets.dart';

class SnackBarClass {
  
  static successSnackBar({required BuildContext context ,required String message}){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        hitTestBehavior: HitTestBehavior.deferToChild,
        content: smallText(title: message,color: AppColor.whiteColor),
        backgroundColor: AppColor.successColor,
        duration: const Duration(seconds: 5),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
        margin:  const  EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        // action: SnackBarAction(
        //   label: "UNDO",
        //   textColor: Colors.white,
        //   onPressed: () {
        //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //   },
        // ),
        dismissDirection: DismissDirection.horizontal,
        onVisible: () {
        },
        showCloseIcon: true,
        closeIconColor: AppColor.whiteColor,
      ),
    );
  }

  static errorSnackBar({required BuildContext context ,required String message}){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        hitTestBehavior: HitTestBehavior.deferToChild,
        content: smallText(title: message,color: AppColor.whiteColor),
        backgroundColor: AppColor.errorColor,
        duration: const Duration(seconds: 5),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
        margin:  const  EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        dismissDirection: DismissDirection.horizontal,
        onVisible: () {
        },
        showCloseIcon: true,
        closeIconColor: AppColor.whiteColor,
      ),
    );
  }

  static warningSnackBar({required BuildContext context ,required String message}){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        hitTestBehavior: HitTestBehavior.deferToChild,
        content: smallText(title: message,color: AppColor.whiteColor),
        backgroundColor: AppColor.warningColor,
        duration: const Duration(seconds: 5),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
        margin:  const  EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        dismissDirection: DismissDirection.horizontal,
        onVisible: () {
        },
        showCloseIcon: true,
        closeIconColor: AppColor.whiteColor,
      ),
    );
  }
  
}