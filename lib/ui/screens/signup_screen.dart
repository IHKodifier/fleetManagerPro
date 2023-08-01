import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleet_manager_pro/states/app_user.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/ui/screens/app_home_screen.dart';
import 'package:fleet_manager_pro/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _password = '';
  bool obscurePassword = true;
  final bool _isBusy = false;
  String _email = '';
  final _formKey = GlobalKey<FormState>();
  late AppUser newUser;

  Future<void> _signup(String email, String password) async {
    final auth = ref.read(firebaseAuthProvider);
    final url = ref.read(defaultPhotoUrlProvider);
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    ///if the user is successfully creaed if Firebase Auth, create [AppUser] and add to 'users' collection in Firestore
    if (credential.user != null) {
      //create appUser
      newUser = AppUser(uuid: credential.user!.uid);
      newUser.email = _email;
      newUser.photoUrl = url;
      newUser.displayName = _displayNameController.text.isEmpty
          ? _email
          : _displayNameController.text;
      newUser.location = _locationController.text.isNotEmpty
          ? _locationController.text
          : 'Not set by user';

      newUser.phone = 'Not set by user';
      newUser.profileType = 'Not set by user';
      //save to Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.uuid)
          .set(newUser.toMap())
          .then(
        (value) {
          ref.read(appUserProvider.notifier).setAppUser(newUser);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const AppHomeScreen(),
          ));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  textAlign:TextAlign.center,
                  
                  'Sign Up',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailController,
                  onSaved: (newValue) {
                    _email = newValue!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(
                      Icons.email,
                      size: 35,
                    ),
                    prefixIconColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordController,
                  onSaved: (newValue) {
                    _password = newValue!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(
                      Icons.key,
                      size: 35,
                    ),
                    prefixIconColor: Theme.of(context).colorScheme.primary,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                  obscureText: obscurePassword,
                ),
              ),
              const Spacer(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _password2Controller,
                  onSaved: (newValue) {
                    // newUser.email = newValue;
                  },
                  validator: (value) {
                    if (
                        value != _passwordController.text) {
                      return 'passwords do not match';
                    }
                    if (value!.isEmpty 
                        ) {
                      return 'Please Confirm your password ';
                    }
                    return null;

                  },
                  decoration: InputDecoration(
                    labelText: ' Confirm Password',
                    prefixIcon: const Icon(
                      Icons.key,
                      size: 35,
                    ),
                    prefixIconColor: Theme.of(context).colorScheme.primary,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                    ),
                  ),
                  obscureText: obscurePassword,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    hintText: 'optional',
                    prefixIcon: const Icon(
                      Icons.person,
                      size: 35,
                    ),
                    prefixIconColor: Theme.of(context).colorScheme.primary,
                  ),
                  // obscureText: true,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location/City',
                    hintText: 'Optional',
                    prefixIcon: const Icon(
                      Icons.location_city,
                      size: 35,
                    ),
                    prefixIconColor: Theme.of(context).colorScheme.primary,
                  ),
                  // obscureText: true,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _signup(_emailController.text,
                                _passwordController.text);
                          }
                        },
                        child: const Text('Sign Up '),
                      ),
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: _isBusy
                            ? const CircularProgressIndicator()
                            : const Text('Go Back'),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(
                flex: 2,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text('Powered by EnigmaTek Inc.'),
                  SizedBox(
                    height: 10,
                  ),
                  // Spacer(flex: 2),
                ],
              ),
              // Text(''),

              // ElevatedButton(
              //   onPressed: () {
              //     // Navigate to LoginScreen
              //   },
              //   child: Text('Already have an account?'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
