import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/conts/list_const.dart';
import 'package:ripverpod_supabase/providers/bottom_nav_provider/bottom_nav_provider.dart';

import '../../conts/colors.dart';
import '../widgets/text_widgets.dart';




class BottomNavScreen extends StatelessWidget {
  final bool isRequestChangeEmail ;
  const BottomNavScreen({super.key,this.isRequestChangeEmail = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context,ref,_){
        var data = ref.watch(bottomNavProvider.select((state)=> state.currentIndex));
        return screens[isRequestChangeEmail == true ? 3 : data];
      }),
      bottomNavigationBar: Consumer(builder: (context,ref,_){
        var data = ref.watch(bottomNavProvider.select((state)=> state.currentIndex));
        return BottomNavigationBar(
          currentIndex: isRequestChangeEmail == true ? 3 : data,
          items: items,
          onTap: (index) {
            ref.read(bottomNavProvider.notifier).changeIndex(index: index);
          },
          selectedItemColor: AppColor.successColor, // Selected icon & text color
          unselectedItemColor: AppColor.disableColor, // Unselected icon & text color
          backgroundColor: AppColor.whiteColor, // Background color of the bar
          selectedLabelStyle: TextWidgets.mediumTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColor.successColor, // Match selected color
          ),
          unselectedLabelStyle: TextWidgets.smallTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColor.disableColor, // Match unselected color
          ),
          iconSize: 24, // Set icon size
        );
      }),
    );
  }
}
