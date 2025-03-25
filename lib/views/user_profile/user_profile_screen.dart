import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/core/models/user_model/user_model.dart';
import 'package:ripverpod_supabase/providers/auth_provider/logout_provider.dart';
import 'package:ripverpod_supabase/providers/auth_provider/password_reset_provider.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/forgot_password.dart';
import 'package:ripverpod_supabase/views/screens/auth_screens/request_change_emial_screen.dart';
import 'package:ripverpod_supabase/views/widgets/custom_button.dart';
import 'package:ripverpod_supabase/views/widgets/custom_loading.dart';
import 'package:ripverpod_supabase/views/widgets/custom_sizedBox.dart';
import 'package:ripverpod_supabase/views/widgets/text_widgets.dart';
import 'package:supabase/supabase.dart';
import '../../conts/colors.dart';
import 'update_user_details.dart';
import '../../providers/user_provider/user_profile_provider.dart';
import '../../services/net_work_excptions.dart';
import 'update_user_profile.dart';


class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: userProfile.when(
        skipLoadingOnReload: false,
        data: (userData) {
          if (userData is List && userData.isNotEmpty) {
            UserModel user = UserModel.fromJson(userData.first);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateUserProfile(userModel: user),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: AppColor.disableColor,
                                  child: largeText(title: user.name[0], color: AppColor.blackColor), // Showing the first letter of the name
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    mediumText(title: user.name),
                                    smallText(
                                      title: user.userName,
                                      color: AppColor.blackColor.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Divider
                          const SizedBox(height: 12),
                          Divider(color: AppColor.disableColor),
                          const SizedBox(height: 12),

                          // Details Section (Tappable)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateUserDetails(userModel: user),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.disableColor.withOpacity(0.1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  mediumText(title: "Bio"),
                                  smallText(title: user.bio, color: AppColor.blackColor.withOpacity(0.7)),
                                  const SizedBox(height: 10),
                                  mediumText(title: "Phone"),
                                  smallText(title: user.phone, color: AppColor.blackColor.withOpacity(0.7)),
                                  const SizedBox(height: 10),
                                  mediumText(title: "Address"),
                                  smallText(title: user.address, color: AppColor.blackColor.withOpacity(0.7)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const  Sized(height: 0.05,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIconButton(
                        radius: 10,
                        width: 0.45,
                        title: 'Change Email',
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const RequestChangeEmail()));
                        },
                        iconData: Icons.email,
                        color: AppColor.blackColor,
                      ),
                      Consumer(builder: (context,ref,_){
                        var data = ref.watch(resetProvider.select((state)=> state.isReAuth));
                        return data == true ? CustomLoading() :CustomIconButton(
                          radius: 10,
                          width: 0.45,
                          title: 'Reset Password',
                          onTap: () {
                            ref.read(resetProvider.notifier).reAuth(email: user.email,context: context, otpType: OtpType.email);
                          },
                          iconData: Icons.email,
                          color: AppColor.blackColor,
                        );
                      }),
                    ],
                  ),
                  const  Sized(height: 0.03),
                  Consumer(builder: (context, ref, _) {
                    var data = ref.watch(logoutProvider.select((state)=> state.isLogout));
                    return data == true ? const CustomLoading() : CustomIconButton(
                      title: 'Logout',
                      onTap: () {
                        ref.read(logoutProvider.notifier).logoutLocal(context: context, scope: SignOutScope.global);
                      },
                      iconData: Icons.logout,
                      color: AppColor.successColor,
                    );
                  }),
                  const  Sized(height: 0.03),
                  Consumer(builder: (context, ref, _) {
                    var data = ref.watch(logoutProvider.select((state)=> state.isDeleteAccount));
                    return data == true ? const CustomLoading() : CustomIconButton(
                      title: 'Delete Account',
                      onTap: () {
                        ref.read(logoutProvider.notifier).deleteUserAccount(context: context);
                      },
                      iconData: Icons.delete,
                      color: AppColor.errorColor,
                    );
                  }),
                ],
              ),
            );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          String errorMessage = ExceptionHandler.getMessage(error);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 50),
                const SizedBox(height: 10),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () =>
                      ref.invalidate(userProfileProvider), // Retry on error
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
