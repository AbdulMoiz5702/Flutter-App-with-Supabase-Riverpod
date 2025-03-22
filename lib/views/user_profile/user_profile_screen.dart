import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripverpod_supabase/core/user_model.dart';

import '../../providers/user_provider/user_profile_provider.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: userProfile.when(
        skipLoadingOnReload: true,
        data: (userData) {
          if (userData is List && userData.isNotEmpty) {
            UserModel user = UserModel.fromJson(userData.first);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: ListTile(
                  title: Text('Name: ${user.name}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${user.email}'),
                      Text('Phone: ${user.phone}'),
                      Text('Address: ${user.phone}'),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: Text('User not found.'));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => ref.invalidate(userProfileProvider), // Retry on error
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
