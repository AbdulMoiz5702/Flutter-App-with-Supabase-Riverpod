import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/conts/colors.dart';


Widget buildStrengthContainer(bool isActive, Color color) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    height: 8,
    width: 50,
    decoration: BoxDecoration(
      color: isActive ? color : AppColor.disableColor,
      borderRadius: BorderRadius.circular(5),
    ),
  );
}