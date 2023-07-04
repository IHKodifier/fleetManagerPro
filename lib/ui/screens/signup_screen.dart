import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

class SignupScreen extends ConsumerStatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _locationCController = TextEditingController();

  Future<void> _signup(String email, String password) async {
    final auth = ref.read(firebaseAuthProvider);
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text('Sign Up',
            style: Theme.of(context)
            .textTheme.headlineLarge,),
            const Spacer(),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const Spacer(),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const Spacer(),
        
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const Spacer(),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Display Name',
              hintText: 'optional'),
              obscureText: true,
            ),
            const Spacer(),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Location/City',
              hintText: 'Optional'),
              obscureText: true,
            ),   
            const Spacer(),
                     Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _signup(_emailController.text, _passwordController.text);
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
                      _signup(_emailController.text, _passwordController.text);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2,),
            const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 10,),
                Text('Powered by EnigmaTek Inc.'),
                SizedBox(height: 10,),
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
    );
  }
}
