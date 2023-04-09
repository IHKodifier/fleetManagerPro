import 'package:flutter/material.dart';

import '../../states/vehicle.dart';

class RegPlate extends StatelessWidget {
  const RegPlate({super.key, required this.state});

  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    print(state.toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 120,
        child: Card(
          // color: Theme.of(context).colorScheme.primaryContainer,
          elevation:10,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Text(state.reg!,
                    style: Theme.of(context).textTheme.displayLarge),
                Text(state.regCity!,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
