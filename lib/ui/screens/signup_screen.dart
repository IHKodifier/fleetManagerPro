import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleet_manager_pro/states/app_user.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/ui/screens/app_home_screen.dart';
import 'package:fleet_manager_pro/ui/screens/login_screen.dart';
import 'package:fleet_manager_pro/ui/shared/hover_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

import '../../app.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late AppUser newUser;
  bool obscurePassword = true;
  late double width;

  final TextEditingController _displayNameController = TextEditingController();
  String _email = '';
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isBusy = false;
  final TextEditingController _locationController = TextEditingController();
  String _password = '';
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      width = constraints.maxWidth;

      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: SizedBox(
              width: ResponsiveBreakpoints.of(context).isMobile
                  ? ResponsiveBreakpoints.of(context).screenWidth * .85
                  : width / 2.1,
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Gap(16),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        'Sign Up',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    Gap(16),

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
                          prefixIconColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    // const Spacer(),
                    Gap(12),

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
                          prefixIconColor:
                              Theme.of(context).colorScheme.primary,
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
                    // const Spacer(),
                    Gap(12),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _password2Controller,
                        onSaved: (newValue) {
                          // newUser.email = newValue;
                        },
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'passwords do not match';
                          }
                          if (value!.isEmpty) {
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
                          prefixIconColor:
                              Theme.of(context).colorScheme.primary,
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
                    // const Spacer(),
                                        Gap(12),

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
                          prefixIconColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        // obscureText: true,
                      ),
                    ),
                    // const Spacer(),
                                        Gap(12),

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
                          prefixIconColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        // obscureText: true,
                      ),
                    ),
                    // const Spacer(),
                                        Gap(12),

                    SizedBox(
                      height: 50,
                      // padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              child: HoverButton(
                                translateTo: TranslateTo.left,
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
                            child: Container(
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
                                },
                                child: _isBusy
                                    ? const CircularProgressIndicator()
                                    : const Text('Go Back'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const Spacer(
                    //   flex: 2,
                    // ),
                                        Gap(12),

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
                        Gap(12),
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
          ),
        ),
      );
    });
  }
}
