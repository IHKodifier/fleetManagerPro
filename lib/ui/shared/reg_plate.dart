import 'package:flutter/material.dart';

import '../../states/vehicle.dart';

class RegPlate extends StatelessWidget {
  final Vehicle state;
  const RegPlate({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 120,
        child: Card(
          color: Theme.of(context).colorScheme.primaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 64),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(state.reg!,
                    style: Theme.of(context).textTheme.displayLarge),
                Text(state.regCity!,
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
