import 'package:flutter/material.dart';import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class OnBoarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        finishButtonText: 'Register',
        skipTextButton: const Text('Skip'),
        trailing: const Text('Login'),
        background: [
          Image.asset('assets/slide_1.png'),
          Image.asset('assets/slide_2.png'),
        ],
        totalPage: 2,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                 SizedBox(
                  height: 480,
                ),
                const Text('Description Text 1'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 480,
                ),
                const Text('Description Text 2'),
              ],
            ),
          ),
        ],
      );
    
  }
}