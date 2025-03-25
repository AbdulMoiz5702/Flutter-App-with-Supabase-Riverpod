import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/conts/colors.dart';
import 'package:ripverpod_supabase/providers/auth_provider/signup_provider.dart';
import 'package:ripverpod_supabase/utils/format_validator.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/login_screen.dart';
import 'package:ripverpod_supabase/views/widgets/custom_button.dart';
import 'package:ripverpod_supabase/views/widgets/custom_loading.dart';
import 'package:ripverpod_supabase/views/widgets/custom_sizedBox.dart';
import 'package:ripverpod_supabase/views/widgets/custom_textfeild.dart';
import '../../../services/supaBase_services.dart';
import '../../widgets/text_widgets.dart';
import '../widgets/buildStrength.dart';
import '../widgets/valadation_item.dart';


class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var provider = ref.watch(signupProvider.notifier);
    var key = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
         physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Form(
            key: key,
            child: Column(
              children: [
                const Sized(height: 0.05,),
                CustomTextField(controller: provider.nameController, hintText: 'Name', validate: (value){
                  return  value.isEmpty ? 'Name required' : null;
                }),
                const Sized(height: 0.02,),
                CustomTextField(controller: provider.emailController, hintText: 'Email', validate: (value){
                  return  FormValidators.validateEmail(value);
                }),
                const Sized(height: 0.02,),
                Consumer(
                  builder: (context, ref, child) {
                    var provider = ref.watch(signupProvider.notifier);
                    var checkUserName = ref.watch(signupProvider.select((state)=> state.checkUserName));
                    return CustomTextField(
                      controller: provider.userNameController,
                      hintText: 'Username',
                      onChanged: (value) => provider.checkUserNameAvailability(context: context),
                      validate: (value) {
                        return FormValidators.validateUserName(value, checkUserName);
                      },
                    );
                  },
                ),
                const Sized(height: 0.02,),
                CustomTextField(
                    controller: provider.passwordController, hintText: 'Password',
                    validate: (value){return  FormValidators.validatePassword(value);},
                    onChanged: (value){
                      ref.read(signupProvider.notifier).updatePasswordStrength();
                  },
                ),
                const Sized(height: 0.02,),
                CustomTextField(controller: provider.confirmPassword, hintText: 'Re type', validate: (value){
                  return FormValidators.validateConfirmPassword(value,provider.confirmPassword.text);
                }),
                const Sized(height: 0.02,),
                Consumer(
                  builder: (context, reference, _) {
                    var buildState = reference.watch(signupProvider.select((state)=> state.password));
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
                      var buildState = reference.watch(signupProvider.select((state)=> state.password));
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
                      var data = reference.watch(signupProvider.select((state)=> state.isLoading));
                      return data == true ? const CustomLoading() : CustomButton(title: 'Signup', onTap: (){
                        if(key.currentState!.validate()){
                          reference.read(signupProvider.notifier).signupUser(context: context);
                        }
                      });
                }),
                const Sized(height: 0.05,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: smallText(title: 'Already have an account? Login'),
                )
              ],
            ),
          )),

    );
  }
}
