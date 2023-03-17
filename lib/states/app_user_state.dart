import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleet_manager_pro/states/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges().asBroadcastStream();
});

final userProvider =
    StateNotifierProvider<AppUserStateNotifier, AppUser?>((ref) {
  return AppUserStateNotifier(ref);
});

class AppUserStateNotifier extends StateNotifier<AppUser?> {
  // final StateNotifierProviderRef<AppUserStateNotifier, AppUser?> ref;
  AppUserStateNotifier(this.ref, [state]) : super(state) {
    ref.listen(
        authStateChangesProvider,
        (previous, next) {
      if (previous != next) {
        //refetch the user doc from forestore and set AppUserState
        final user = FirebaseAuth.instance.currentUser.u

        FirebaseFirestore.instance
            .collection('users')
            .where('userId', isEqualTo: user?.email)
            .get()
            .then((value) {
          final user = AppUser.fromMap(value.docs[0].data());
          state = user;
        });
      }
    });

    void setUser(AppUser user) {
      state = user;
    }

    void clearUser() {
      state = null;
    }
  }

  final StateNotifierProviderRef<AppUserStateNotifier, AppUser?> ref;
}
