import 'package:flutter/material.dart';

import '../../states/vehicle.dart';

class RegPlate extends StatelessWidget {
  const RegPlate({super.key, required this.state});

  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(state.toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 220,
        height: 96,
        child: Card(
          
          color: Colors.white,
          elevation:10,
          // margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
          
                
            
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(state.reg!,
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w400,
                          color: Colors.black)),
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Expanded(
                        child: Text(state.regCity!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400,
                            color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              // Spacer(flex: 4,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
