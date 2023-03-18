import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleet_manager_pro/states/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges().asBroadcastStream();
});

final appUserProvider =
    StateNotifierProvider<AppUserStateNotifier, AppUser?>((ref) {
  return AppUserStateNotifier(ref);
});

class AppUserStateNotifier extends StateNotifier<AppUser?> {
  AppUserStateNotifier(this.ref, [state]) : super(state) {
    ref.listen(authStateChangesProvider, (previous, next) {
      if (previous != next) {
        //refetch the user doc from forestore and set AppUserState
        final user = FirebaseAuth.instance.currentUser;

        FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .get()
          .then((value) 
          
          {
          final appUser = AppUser.fromMap(value.data()!);
         setAppUser(appUser);
        });
      }
    });
  }

  final StateNotifierProviderRef<AppUserStateNotifier, AppUser?> ref;

  void clearUser() {
      state = null;
    }

   void setAppUser(AppUser appUser) {

      state = appUser;
    }
}
