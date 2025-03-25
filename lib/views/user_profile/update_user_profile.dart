import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/providers/user_provider/user_profile_provider.dart';
import 'package:ripverpod_supabase/utils/format_validator.dart';
import 'package:ripverpod_supabase/views/widgets/custom_button.dart';
import 'package:ripverpod_supabase/views/widgets/custom_loading.dart';
import 'package:ripverpod_supabase/views/widgets/custom_sizedBox.dart';
import 'package:ripverpod_supabase/views/widgets/custom_textfeild.dart';
import 'package:ripverpod_supabase/views/widgets/text_widgets.dart';
import '../../core/models/user_model/user_model.dart';

class UpdateUserProfile extends ConsumerStatefulWidget {
  final UserModel userModel;
  const UpdateUserProfile({super.key, required this.userModel});

  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends ConsumerState<UpdateUserProfile> {

  @override
  void initState() {
    super.initState();
    Future.microtask((){
      var provider = ref.watch(userProfileUpdate.notifier);
      provider.name.text =  widget.userModel.name;
      provider.userName.text =  widget.userModel.userName;
    });
  }


  @override
  Widget build(BuildContext context) {
    var key = GlobalKey<FormState>();
    var provider = ref.watch(userProfileUpdate.notifier);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: mediumText(title: 'Edit Profile'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Form(
          key: key,
          child: Column(
            children: [
              const Sized(height: 0.05,),
              const Sized(height: 0.02,),
              CustomTextField(
                keyboardType: TextInputType.streetAddress,
                controller: provider.name,
                hintText: 'Name',
                validate: (value) {
                  return FormValidators.validateNormalField(value, 'Name');
                },
              ),
              const Sized(height: 0.02,),
              Consumer(
                builder: (context, ref, child) {
                  var provider = ref.watch(userProfileUpdate.notifier);
                  var checkUserName = ref.watch(userProfileUpdate.select((state)=> state.checkUserName));
                  return CustomTextField(
                    controller: provider.userName,
                    hintText: 'Username',
                    onChanged: (value) => provider.checkUserNameAvailability(context: context),
                    validate: (value) {
                      return FormValidators.validateUserName(value, checkUserName);
                    },
                  );
                },
              ),
              const Sized(height: 0.05,),
              Consumer(builder: (context,ref,_){
                var data = ref.watch(userProfileUpdate.select((state)=> state.isLoading));
                return data == true ? const CustomLoading(): CustomButton(title: 'Save', onTap: (){
                 if(key.currentState!.validate()){
                   ref.read(userProfileUpdate.notifier).updateUserProfile(context: context);
                 }
                });
              })

            ],
          ),
        ),
      ),
    );
  }
}

