import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/providers/auth_provider/password_reset_provider.dart';

import '../../../utils/format_validator.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loading.dart';
import '../../widgets/custom_sizedBox.dart';
import '../../widgets/custom_textfeild.dart';



class UpdatePassword extends ConsumerWidget {
  const UpdatePassword({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var provider = ref.watch(resetProvider.notifier);
    var key = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Form(
          key: key,
          child: Column(
            children: [
              const Sized(height: 0.05,),
              CustomTextField(controller: provider.updatePasswordController, hintText: 'New Password', validate: (value){
                return  FormValidators.validatePassword(value);
              }),
              const Sized(height: 0.05,),
              Consumer(
                  builder: (context,reference,_){
                    var data = reference.watch(resetProvider.select((state)=> state.isLoading));
                    return data == true ? const CustomLoading() : CustomButton(title: 'Confirm', onTap: (){
                      if(key.currentState!.validate()){
                        reference.read(resetProvider.notifier).updatePassword(context: context);
                      }
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}


