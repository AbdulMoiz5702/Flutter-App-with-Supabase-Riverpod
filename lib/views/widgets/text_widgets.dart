import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../conts/colors.dart';

Widget largeText({
  required String title,
  context,
  double fontSize = 22,
  double height = 1.1,
  fontWeight = FontWeight.w700,
  color = AppColor.blackColor,
}) {
  return Text(
    title,
    style: GoogleFonts.specialElite(
        textStyle: TextStyle(
      height: height.toDouble(),
      fontSize: fontSize.toDouble(),
      fontWeight: fontWeight,
      color: color,
    )),
  );
}

Widget mediumText({
  required String title,
  context,
  double fontSize = 14,
  fontWeight = FontWeight.bold,
  Color color = AppColor.blackColor,
}) {
  return Text(
    title,
    style: GoogleFonts.specialElite(
        textStyle: TextStyle(
      fontSize: fontSize.toDouble(),
      fontWeight: fontWeight,
      color: color,
    )),
  );
}

Widget smallText({
  required String title,
  context,
  double fontSize = 12,
  fontWeight = FontWeight.w400,
  color = AppColor.blackColor,
}) {
  return Text(
    title,
    style: GoogleFonts.specialElite(
        textStyle: TextStyle(
      fontSize: fontSize.toDouble(),
      fontWeight: fontWeight,
      color: color,
    )),
    softWrap: true,
    maxLines: 10,
    overflow: TextOverflow.ellipsis,
  );
}

class TextWidgets {
  static TextStyle smallTextStyle(
      {double fontSize = 12,
      fontWeight = FontWeight.w400,
      color = AppColor.blackColor,
      TextOverflow overflow = TextOverflow.clip}) {
    return GoogleFonts.specialElite(
        textStyle: TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize.toDouble(),
      overflow: overflow,
    ));
  }

  static TextStyle mediumTextStyle(
      {double fontSize = 14,
      fontWeight = FontWeight.bold,
      Color color = AppColor.blackColor,
      TextOverflow overflow = TextOverflow.clip}) {
    return GoogleFonts.specialElite(
        textStyle: TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize.toDouble(),
      overflow: overflow,
    ));
  }

  static TextStyle largeTextStyle(
      {double fontSize = 25,
      double height = 1.1,
      fontWeight = FontWeight.w700,
      color = AppColor.blackColor,
      TextOverflow overflow = TextOverflow.clip}) {
    return GoogleFonts.specialElite(
        textStyle: TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize.toDouble(),
      overflow: overflow,
    ));
  }
}
