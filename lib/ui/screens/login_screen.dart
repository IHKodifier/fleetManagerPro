// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/ui/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:introduction_screen/introduction_screen.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isBusy = false;
  bool passwordIsVisible = false;

  Future<void> _login() async {
    setState(() {
      isBusy = true;
    });
    final auth = ref.read(firebaseAuthProvider);
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      // final errorcode = e.code;
      String errorMessage = '';

      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Please Enter correct password';
          break;
        case 'network-request-failed':
          errorMessage = 'No Internet Connection';
          break;
        case 'user-not-found':
          errorMessage = 'User does not exist';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts please try later';
          break;
        case 'unknown':
          errorMessage = 'Email and password field are required';
          break;
        case 'invalid-email':
          errorMessage = 'Email address is badly formatted';
          break;

        default:
          errorMessage = 'Some error ocurred. Please try later!';
      }
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Icon(
                  Icons.warning_amber, size: 50,
                  // color: Theme.of(context).colorScheme.error,
                ),
                content: Text(
                  errorMessage,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.red),
                ),
                actions: [
                  Row(
                    children: [
                      TextButton(
                          onPressed: _frorgotPassword,
                          child: const Text('Forgot Password')),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Try again'))),
                    ],
                  ),
                ],
              ));
    } finally {
      setState(() {
        isBusy = false;
      });
    }
  }

  Future<User?> _signInWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
        //TODO add user doc in [users] collection firebase
        if (user != null) {
          AppUser appUser = AppUser(uuid: user.uid);
          appUser.email = user.email;
          appUser.location = 'not defined';
          appUser.displayName = user.displayName;
          appUser.phone = user.phoneNumber;
          appUser.profileType = 'Individual';
          appUser.photoUrl = user.photoURL;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(appUser.uuid)
              .set(appUser.toMap(), SetOptions(merge: true));
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
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: Text('Login')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              // shrinkWrap: true,
              children: [
                const Spacer(
                  flex: 1,
                ),
                Text(
                  'Welcome to Fleet Manager Pro!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  flex: 5,
                  child: PageView(
                    children: [
                      Card(
                        // color: Color s.green,
                        child: Image.asset(
                          'assets/intro 1.jpg',
                          height: 350,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Card(
                        // color: Colors.green,
                        child: Image.asset(
                          'assets/intro 2.jpg',
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Card(
                        // color: Colors.green,
                        child: Image.asset(
                          'assets/intro 01.png',
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your One Stop shop to manage all your vehicles  and their service History',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(
                  flex: 1,
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 4.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordIsVisible = !passwordIsVisible;
                        });
                      },
                      icon: Icon(passwordIsVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                  obscureText: !passwordIsVisible,
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to SignUpScreen
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignupScreen(),));
                          print('naviga te sign up');
                        },
                        child: const Text('Sign Up'),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _login,
                        child: !isBusy
                            ? const Text('Login')
                            : Center(
                                child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                const Row(
                  children: [],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          await _signInWithGoogle();
                        },
                        child: const Text('Login with Google'),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _frorgotPassword() async {
    // Send a password reset email to the u
    //  ser's email address.
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _usernameController.text);
      print('**********************EMAIL SENT*************');
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Password recovery email sent'),
                content: Text(
                    'we have sent a password recovery email to \n${_usernameController.text}\n Please follow the instruction in the email to reset your password for Fleet Manager Pro'),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: const FittedBox(child: Text('Continue')),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ));
    } catch (e) {
      print(e.toString());
    }
  }
}
