import 'package:flutter/material.dart';

class IncompatibleDeviceWidget extends StatelessWidget {
  const IncompatibleDeviceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Material(
      child: Container(
        color: Colors.orange,
        child: Center(child: 
        Text(
'''This device\'s screen size is not supported by this app. 
 Try on a device with larger screen.''',
 style: Theme.of(context).textTheme.headlineSmall,)),
      ),
    );
  }
}