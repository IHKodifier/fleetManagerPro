import 'package:fleet_manager_pro/welcome_screen.dart';
import 'package:flutter/material.dart';import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class OnBoarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        finishButtonText: 'Register',
        skipTextButton: const Text('Skip Intro'),
        trailing: const Text('Login'),
        background: [
          Image.asset('assets/background.png'),
          Image.asset('assets/app_icon.png'),
          Image.asset('assets/car.jpg'),
        ],
        totalPage: 3,
        speed: 1.8,
        pageBodies: const [
          PageOne(),
      
          PageTwo(),
          PageThree(),

        ],
      );
    
  }
}

class PageTwo extends StatelessWidget {
  const PageTwo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 480,
          ),
          Text('Page Two'),
        ],
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  const PageOne({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 40),
      child: const WelcomScreen(),);
  }
}
class PageThree extends StatelessWidget {
  const PageThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}