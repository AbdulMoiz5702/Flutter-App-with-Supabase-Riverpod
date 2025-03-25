import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/providers/user_provider/user_profile_provider.dart';
import 'package:ripverpod_supabase/views/widgets/custom_button.dart';
import 'package:ripverpod_supabase/views/widgets/custom_loading.dart';
import 'package:ripverpod_supabase/views/widgets/custom_sizedBox.dart';
import 'package:ripverpod_supabase/views/widgets/custom_textfeild.dart';
import 'package:ripverpod_supabase/views/widgets/text_widgets.dart';
import '../../core/models/user_model/user_model.dart';

class UpdateUserDetails extends ConsumerStatefulWidget {
  final UserModel userModel;
  const UpdateUserDetails({super.key, required this.userModel});

  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends ConsumerState<UpdateUserDetails> {

  @override
  void initState() {
    super.initState();
    Future.microtask((){
      var provider = ref.watch(userProfileUpdate.notifier);
      provider.bio.text =  widget.userModel.bio;
      provider.address.text =  widget.userModel.address;
      provider.phone.text =  widget.userModel.phone;
    });
  }


  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(userProfileUpdate.notifier);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: mediumText(title: 'Edit Details'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            const Sized(height: 0.05,),
            CustomTextField(
              maxLine: 4,
              controller: provider.bio,
              hintText: 'Bio',
              validate: (value) {},
            ),
            const Sized(height: 0.02,),
            CustomTextField(
              keyboardType: TextInputType.streetAddress,
              controller: provider.address,
              hintText: 'Address',
              validate: (value) {},
            ),
            const Sized(height: 0.02,),
            CustomTextField(
              keyboardType: TextInputType.phone,
              controller: provider.phone,
              hintText: 'Phone',
              validate: (value) {},
            ),
            const Sized(height: 0.05,),
            Consumer(builder: (context,ref,_){
              var data = ref.watch(userProfileUpdate.select((state)=> state.isSecondLoading));
              return data == true ? const CustomLoading(): CustomButton(title: 'Save', onTap: (){
                ref.read(userProfileUpdate.notifier).updateUserDetails(context: context);
              });
            })

          ],
        ),
      ),
    );
  }
}

