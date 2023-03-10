import 'package:fleet_manager_pro/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
// import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        onDone: () {},
        // done: (){},
        // overrideDone:(){} ,
        showDoneButton: true,
        showNextButton: false,
        // show
        pages: [
          PageViewModel(
            title: "Welcome to Fleet Manager Prooooo",

            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("Click on "),
                Icon(Icons.edit),
                Text(" to edit a post"),
              ],
            ),
            // body: "Manage  you entire fleet maintenance right fom your smart phone",
            image: Center(
              child: Image.asset('assets/car.jpg'),
            ),
          ),
          PageViewModel(
            title: "Title of introduction page",
            body: "Welcome to the app! This is a description of how it works.",
            image: const Center(
              child: Icon(Icons.waving_hand, size: 50.0),
            ),
          ),
          PageViewModel(
            title: "Title of introduction page",
            body: "Welcome to the app! This is a description of how it works.",
            image: const Center(
              child: Icon(Icons.waving_hand, size: 50.0),
            ),
          ),
          PageViewModel(
            title: "Title of introduction page",
            body: "Welcome to the app! This is a description of how it works.",
            image: const Center(
              child: Icon(Icons.waving_hand, size: 50.0),
            ),
          ),
        ],
      ),
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
        children: const <Widget>[
          SizedBox(
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
      child: const WelcomScreen(),
    );
  }
}

class PageThree extends StatelessWidget {
  const PageThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
