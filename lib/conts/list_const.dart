import 'package:flutter/material.dart';
import 'package:ripverpod_supabase/views/user_profile/user_profile_screen.dart';

import 'colors.dart';


List<BottomNavigationBarItem> items = [
  const BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
  const BottomNavigationBarItem(icon: Icon(Icons.explore),label: 'Explore'),
  const BottomNavigationBarItem(icon: Icon(Icons.video_library),label: 'Watch'),
  const BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: 'Profile'),
];

List<Widget> screens =  [
  Container(color: AppColor.successColor,),
  Container(color: AppColor.warningColor,),
  Container(color: AppColor.errorColor,),
  const UserProfileScreen(),
];




