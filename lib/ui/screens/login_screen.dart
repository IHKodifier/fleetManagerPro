// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/ui/screens/signup_screen.dart';
import 'package:fleet_manager_pro/ui/shared/hover_button.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:responsive_framework/responsive_framework.dart';
// import 'package:flutter_animate/flutter_animate.dart';
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isBusy = false;
  bool passwordIsVisible = false;
  late double width;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  Expanded signInWithGoogleButton() {
    return Expanded(
      child: Container(
        height: 50,
        child: OutlinedButton(
          onPressed: () async {
            await _signInWithGoogle();
          },
          child: const Text('Login with Google'),
        ),
      ),
    );
  }

  Expanded signInButton(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        height: 50,
        child: HoverButton(
          translateTo: TranslateTo.right,
          child: ElevatedButton(
            onPressed: _login,
            child: !isBusy
                ? const Text('Login')
                : Center(
                    child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )),
          ),
        )
      ),
    );
  }

  Expanded signupButton(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        height: 50,
        child: HoverButton(
          translateTo: TranslateTo.left,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to SignUpScreen
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SignupScreen(),
              ));
            },
            child: const Text('Sign Up'),
          ),
        ),
      ),
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              passwordIsVisible = !passwordIsVisible;
            });
          },
          icon:
              Icon(passwordIsVisible ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      obscureText: !passwordIsVisible,
    );
  }

  TextFormField userNameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(labelText: 'Username'),
    );
  }

  Widget oneStopShop(BuildContext context) {
    return Text(
      'Your One Stop shop to manage all your vehicles  and their service History, All in One Place ',
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Expanded repairGraphic() {
    return Expanded(
      flex: 2,
      child: PageView(
        children: [
          Container(
            // color: Color s.green,
            child: Image.asset(
              'assets/intro 1.jpg',
              height: 250,
              fit: BoxFit.scaleDown,
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
    );
  }

  Text welcomeBanner(BuildContext context) {
    return Text(
      'Welcome to Fleet Manager Pro!',
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }

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
                title: const Icon(
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

  @override
  Widget build(BuildContext context) {
    // var width;
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            width = constraints.maxWidth;

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  // height: 150,
                  child: Column( 
                    // mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // shrinkWrap: true,
                    children: [
                      // Gap(80),
                      welcomeBanner(context),
                      repairGraphic(),
                      SizedBox(
                        width: ResponsiveBreakpoints.of(context).isMobile?
                        ResponsiveBreakpoints.of(context).screenWidth*.85:
                        width / 2.1,
                        child: Column(
                          children: [
                            oneStopShop(context),
                            Gap(20),
                            userNameField(),
                            Gap(12),
                            passwordField(),
                            Gap(12),
                            Row(
                              children: [
                                signupButton(context),
                                Gap(12),
                                signInButton(context),
                              ],
                            ),
                            Gap(12),
                            Row(
                              children: [
                                signInWithGoogleButton(),
                              ],
                            ),
                            Gap(12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
