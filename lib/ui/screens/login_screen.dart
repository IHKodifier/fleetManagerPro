import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final auth = ref.read(firebaseAuthProvider);
    final credential = await auth.signInWithEmailAndPassword(
      email: _usernameController.text,
      password: _passwordController.text,
    );
  }

Future<User?> _signInWithGoogle() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential = await auth.signInWithCredential(credential);
      user = userCredential.user;
      //TODO add user doc in [users] collection firebase
      if (user!=null){
        AppUser appUser= AppUser(uuid: user.uid);
        appUser.email= user.email;
        appUser.location='not defined';
        appUser.displayName= user.displayName;
        appUser.phone= user.phoneNumber;
        appUser.profileType= 'Individual';
        appUser.photoUrl=user.photoURL;
       await  FirebaseFirestore.instance.collection('users').doc(appUser.uuid).set(appUser.toMap(),SetOptions(merge: true));
       ref.read(appUserProvider.notifier).setAppUser(appUser);

      }

    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }
// AppUser
  return user;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to SignUpScreen
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 16.0),
            OutlinedButton(
              onPressed: () async {
                await _signInWithGoogle();
              },
              child: Text('Login with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
