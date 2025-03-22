
import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/conts/colors.dart';
import 'package:ripverpod_supabase/views/widgets/custom_sizedBox.dart';
import 'package:ripverpod_supabase/views/widgets/text_widgets.dart';

Widget buildValidationItem(String text, bool isValid) {
  return Row(
    children: [
      Icon(isValid ? Icons.check_circle : Icons.cancel, color: isValid ? AppColor.successColor :  AppColor.errorColor,size: 12,),
      const Sized(width: 0.03,),
      smallText(title: text,color: isValid ? AppColor.successColor :  AppColor.errorColor)
    ],
  );
}