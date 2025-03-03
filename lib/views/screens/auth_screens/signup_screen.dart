import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/providers/auth_provider/signup_provider.dart';
import 'package:ripverpod_supabase/utils/format_validator.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/login_screen.dart';
import 'package:ripverpod_supabase/views/widgets/custom_button.dart';
import 'package:ripverpod_supabase/views/widgets/custom_loading.dart';
import 'package:ripverpod_supabase/views/widgets/custom_sizedBox.dart';
import 'package:ripverpod_supabase/views/widgets/custom_textfeild.dart';
import '../../widgets/text_widgets.dart';


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
                CustomTextField(controller: provider.emailController, hintText: 'Email', validate: (value){
                  return  FormValidators.validateEmail(value);
                }),
                const Sized(height: 0.02,),
                CustomTextField(controller: provider.passwordController, hintText: 'Password', validate: (value){
                  return  FormValidators.validatePassword(value);
                }),
                const Sized(height: 0.02,),
                CustomTextField(controller: provider.confirmPassword, hintText: 'Re type', validate: (value){
                  return FormValidators.validateConfirmPassword(value,provider.confirmPassword.text);
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
