import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../states/vehicle.dart';

class RegPlate extends StatelessWidget {
  const RegPlate({super.key, required this.state});

  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    // final screenWidth = ResponsiveBreakpoints.of(context).screenWidth;
    // final regPlateWidth = ResponsiveValue<double>(context,
    //     defaultValue: screenWidth * .65,
    //     conditionalValues: [
    //       Condition.smallerThan(name: TABLET, value: screenWidth * .85),
    //       // Condition.equals(name: name, value: value)
    //     ]).value;
    print(state.toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        // color: Colors.yellow,
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              Flexible(
                flex:1,
                fit: FlexFit.tight,
                 child: RegPlateWidget(state: state)),
              // Spacer(flex: 4,),
            ],
          ),
        ),
      ),
    );
  }
}

class RegPlateWidget extends StatelessWidget {
  const RegPlateWidget({
    super.key,
    required this.state,
  });

  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    // final screenWidth= ResponsiveBreakpoints.of(context).screenWidth;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          child: Text(state.reg!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(
                    // fontSize: 20,
                    fontWeight: FontWeight.w400, 
                    color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ),
        Text(state.regCity!,
            // maxLines: 3,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(fontWeight: FontWeight.w400, 
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
