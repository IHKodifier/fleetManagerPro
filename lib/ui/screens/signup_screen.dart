import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/app_user.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/ui/screens/app_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

class SignupScreen extends ConsumerStatefulWidget {
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
  bool _isBusy=false;
  String _email = '';
  final _formKey = GlobalKey<FormState>();
  late AppUser newUser;

  Future<void> _signup(String email, String password) async {
    
    final auth = ref.read(firebaseAuthProvider);
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    ///if the user is successfully creaed if Firebase Auth, create [AppUser] and add to 'users' collection in Firestore
    if (credential.user != null) {
      //create appUser
      newUser = AppUser(uuid: credential.user!.uid);
      newUser.email = _email;
      newUser.displayName = _displayNameController.text.isEmpty? _email:_displayNameController.text;
      newUser.location = _locationController.text.isNotEmpty? _locationController.text:'not set by user';
      newUser.phone = 'not set by user';
      //save to Firestore
      FirebaseFirestore.instance.collection('users').doc(newUser.uuid).set(newUser.toMap()).then((value) {
        ref.read(appUserProvider.notifier).setAppUser(newUser);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AppHomeScreen(),));
      },);

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
                  'Sign Up',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const Spacer(),
              TextFormField(
                controller: _emailController,
                onSaved: (newValue) {
                  _email = newValue!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email is required';
                  }
                },
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const Spacer(),
              TextFormField(
                controller: _passwordController,
                onSaved: (newValue) {
                  _password = newValue!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password is required';
                  }
                },
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const Spacer(),

              TextFormField(
                controller: _password2Controller,
                onSaved: (newValue) {
                  // newUser.email = newValue;
                },
                validator: (value) {
                  if (value!.isNotEmpty && value != _passwordController.text) {
                    return 'passwords do not match';
                  }
                },
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              const Spacer(),
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                    labelText: 'Display Name', hintText: 'optional'),
                // obscureText: true,
              ),
              const Spacer(),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                    labelText: 'Location/City', hintText: 'Optional'),
                // obscureText: true,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                          _signup(
                            _emailController.text, _passwordController.text);
                        }
                        
                      },
                      child: const Text('Sign Up '),
                    ),
                  ),
                ],
              ),

              // SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          setState(() {
                            _isBusy=true;
                          });
                          _signup(
                            _emailController.text, _passwordController.text);
                        }
                        
                      },
                      child: _isBusy?CircularProgressIndicator(): Text('Cancel'),
                    ),
                  ),
                ],
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
