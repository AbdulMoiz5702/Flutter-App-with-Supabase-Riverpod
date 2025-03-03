import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/providers/auth_provider/otp_provider.dart';
import '../../../providers/auth_provider/login_provider.dart';
import '../../../utils/format_validator.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loading.dart';
import '../../widgets/custom_sizedBox.dart';
import '../../widgets/custom_textfeild.dart';
import '../../widgets/text_widgets.dart';



class ForgotPassword extends ConsumerWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var provider = ref.watch(loginProvider.notifier);
    var providerOtp = ref.watch(otpProvider.notifier);
    var key = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding:const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Form(
          key: key,
          child: Column(
            children: [
              const Sized(height: 0.05,),
              CustomTextField(controller: provider.emailController, hintText: 'Email', validate: (value){
                return  FormValidators.validateEmail(value);
              }),
              const Sized(height: 0.05,),
              Consumer(
                  builder: (context,reference,_){
                    var data = reference.watch(loginProvider.select((state)=> state.forgotLoading));
                    return data == true ? const CustomLoading() : CustomButton(title: 'Send Email', onTap: (){
                      if(key.currentState!.validate()){
                        reference.read(loginProvider.notifier).forgotPassword(context: context);
                      }
                    });
                  }),
              const Sized(height: 0.05,),
              Consumer(
                  builder: (context,reference,_){
                    var data = reference.watch(loginProvider.select((state)=> state.otpLoading));
                    return data == true ? const CustomLoading() : GestureDetector(
                      onTap: () {
                        provider.loginWithOtp(context: context);
                      },
                      child: smallText(title: 'Login with OTP'),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
