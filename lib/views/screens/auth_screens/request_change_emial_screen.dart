import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/providers/auth_provider/password_reset_provider.dart';
import '../../../utils/format_validator.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loading.dart';
import '../../widgets/custom_sizedBox.dart';
import '../../widgets/custom_textfeild.dart';




class RequestChangeEmail extends ConsumerWidget {
  const RequestChangeEmail({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var provider = ref.watch(resetProvider.notifier);
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
              CustomTextField(controller: provider.updateEmailController, hintText: 'Email', validate: (value){
                return  FormValidators.validateEmail(value);
              }),
              const Sized(height: 0.05,),
              Consumer(
                  builder: (context,reference,_){
                    var data = reference.watch(resetProvider.select((state)=> state.isChangeEmail));
                    return data == true ? const CustomLoading() : CustomButton(title: 'Send OTP', onTap: (){
                      if(key.currentState!.validate()){
                        reference.read(resetProvider.notifier).updateEmail(context: context);
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
