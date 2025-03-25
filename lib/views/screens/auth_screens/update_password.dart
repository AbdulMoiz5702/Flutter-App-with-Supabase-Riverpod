import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/providers/auth_provider/password_reset_provider.dart';

import '../../../conts/colors.dart';
import '../../../utils/format_validator.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loading.dart';
import '../../widgets/custom_sizedBox.dart';
import '../../widgets/custom_textfeild.dart';
import '../widgets/buildStrength.dart';
import '../widgets/valadation_item.dart';



class UpdatePassword extends ConsumerWidget {
  const UpdatePassword({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var provider = ref.watch(resetProvider.notifier);
    var key = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Form(
          key: key,
          child: Column(
            children: [
              const Sized(height: 0.05,),
              CustomTextField(controller: provider.updatePasswordController, hintText: 'New Password', validate: (value){
                return  FormValidators.validatePassword(value);
              }),
              const Sized(height: 0.02,),
              CustomTextField(controller: provider.confirmUpdatePasswordController, hintText: 'Confirm Password Password', validate: (value){
                return  FormValidators.validateConfirmPassword(value, provider.updatePasswordController.text.trim());
              }),
              const Sized(height: 0.02,),
              Consumer(
                builder: (context, reference, _) {
                  var buildState = reference.watch(resetProvider.select((state)=> state.password));
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildStrengthContainer(FormValidators.strength(buildState) == 1, AppColor.errorColor),
                      const SizedBox(width: 8),
                      buildStrengthContainer(FormValidators.strength(buildState) == 2, AppColor.warningColor),
                      const SizedBox(width: 8),
                      buildStrengthContainer(FormValidators.strength(buildState) == 3, AppColor.successColor),
                    ],
                  );
                },
              ),
              const Sized(height: 0.02,),
              Consumer(
                  builder: (context,reference,_){
                    var buildState = reference.watch(resetProvider.select((state)=> state.password));
                    return Column(
                      children: [
                        buildValidationItem("At least 8 characters", FormValidators.hasMinLength(buildState)),
                        buildValidationItem("Contains an uppercase letter", FormValidators.hasUpperCase(buildState)),
                        buildValidationItem("Contains a special character", FormValidators.hasSpecialChar(buildState)),
                      ],
                    );
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


