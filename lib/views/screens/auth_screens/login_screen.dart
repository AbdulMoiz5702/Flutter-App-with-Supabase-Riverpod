import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/providers/auth_provider/login_provider.dart';
import 'package:ripverpod_supabase/utils/format_validator.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/forgot_password.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/signup_screen.dart';
import 'package:ripverpod_supabase/views/widgets/custom_button.dart';
import 'package:ripverpod_supabase/views/widgets/custom_loading.dart';
import 'package:ripverpod_supabase/views/widgets/custom_sizedBox.dart';
import 'package:ripverpod_supabase/views/widgets/custom_textfeild.dart';
import 'package:ripverpod_supabase/views/widgets/text_widgets.dart';


class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var provider = ref.watch(loginProvider.notifier);
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
                const Sized(height: 0.05,),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPassword()),
                      );
                    },
                    child: smallText(title: 'Forgot Password?'),
                  ),
                ),
                const Sized(height: 0.05,),
                Consumer(
                    builder: (context,reference,_){
                      var data = reference.watch(loginProvider.select((state)=> state.isLoading));
                      return data == true ? const CustomLoading() : CustomButton(title: 'Login', onTap: (){
                        if(key.currentState!.validate()){
                          reference.read(loginProvider.notifier).loginUser(context: context);
                        }
                      });
                    }),
                const Sized(height: 0.05,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                  child: smallText(title: 'Don\'t  have an account? Create Account'),
                )

              ],
            ),
          )),

    );
  }
}
