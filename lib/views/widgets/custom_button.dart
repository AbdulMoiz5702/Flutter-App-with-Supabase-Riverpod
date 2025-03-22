import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/views/widgets/text_widgets.dart';

import '../../conts/colors.dart';




class CustomButton extends StatelessWidget {
  final String title ;
  final VoidCallback onTap;
  final double height ;
  final double width ;
  final Color color ;
  final double fontSize;
  final FontWeight fontWeight ;
  const CustomButton({super.key,required this.title,required this.onTap,this.height = 0.06,this.width = 1,this.color = AppColor.blackColor,this.fontSize = 16.0,this.fontWeight = FontWeight.w700});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.sizeOf(context).height *height ,
        width: MediaQuery.sizeOf(context).width * width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color,
        ),
        child: mediumText(title: title,context: context,fontSize: fontSize.toDouble(),color: AppColor.whiteColor,fontWeight:fontWeight ),
      ),
    );
  }
}
