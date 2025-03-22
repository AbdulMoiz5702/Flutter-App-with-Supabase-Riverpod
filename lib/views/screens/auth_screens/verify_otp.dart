import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripverpod_supabase/conts/colors.dart';
import 'package:ripverpod_supabase/views/widgets/custom_button.dart';
import 'package:ripverpod_supabase/views/widgets/custom_sizedBox.dart';
import 'package:ripverpod_supabase/views/widgets/text_widgets.dart';
import 'package:supabase/supabase.dart';
import '../../../providers/auth_provider/otp_provider.dart';
import '../../widgets/custom_loading.dart';



class VerifyOtp extends ConsumerWidget {
  final String email;
  final OtpType otpType ;
  final bool isLogin;
  const VerifyOtp({super.key,required this.email,required this.otpType,required this.isLogin});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var data = ref.watch(otpProvider.notifier);
    var key = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Sized(height: 0.3,),
              OtpTextField(
                numberOfFields: 6,
                borderColor: AppColor.blackColor.withOpacity(0.5),
                focusedBorderColor: AppColor.blackColor,
                styles:List.generate(6, (index) => GoogleFonts.specialElite(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColor.blackColor,
                ),
              )),
                showFieldAsBox: false,
                borderWidth: 4.0,
                onCodeChanged: (String code) {
                  data.otpController.text = code;
                },
                onSubmit: (String verificationCode) {
                  data.otpController.text = verificationCode;
                },
              ),
              const Sized(height: 0.05,),
              Consumer(
                  builder: (context,reference,_){
                    var data = reference.watch(otpProvider.select((state)=> state.isLoading));
                    return data == true ? const CustomLoading() : CustomButton(title:isLogin == true ? 'Login' :'Signup', onTap: (){
                      if(key.currentState!.validate()){
                        reference.read(otpProvider.notifier).confirmOtp(email: email, context: context,otpType:otpType,);
                      }
                    });
                  }),
              const Sized(height: 0.03,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  smallText(title: "Haven't received your OTP?",color: AppColor.blackColor),
                  const Sized(width: 0.02,),
                  Consumer(
                    builder: (context, reference, _) {
                      var data = reference.watch(otpProvider);
                      return data.secondsRemaining > 0
                          ? Text("Resend in ${data.secondsRemaining}s")  // Show countdown
                          : data.resendLoading == true ? const CustomLoading() :InkWell(
                        onTap: () {
                          reference.read(otpProvider.notifier).resendOtp(email: email, context: context,otpType: otpType);
                        },
                        child: mediumText(title: 'Resend'),
                      );
                    },
                  ),


                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
