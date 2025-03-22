import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/conts/colors.dart';


class CustomLoading extends StatelessWidget {
  final Color color;
  const CustomLoading({super.key,this.color = AppColor.blackColor});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: CircularProgressIndicator(color: color,),
    );
  }
}





