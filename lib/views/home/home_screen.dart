import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/providers/auth_provider/link_identity_provider.dart';
import 'package:ripverpod_supabase/views/widgets/text_widgets.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_loading.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: mediumText(title: 'Home Screen'),
      ),
      body:  Column(
        children: [
          Consumer(
              builder: (context,reference,_){
                var data = reference.watch(linkIdentityProvider.select((state)=> state.isLoading));
                return data == true ? const CustomLoading() : CustomButton(title: 'Google', onTap: (){
                  reference.read(linkIdentityProvider.notifier).signInWithGoogle();
                });
              }),
        ],
      ),
    );
  }
}
