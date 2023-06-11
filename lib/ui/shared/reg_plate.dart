import 'package:flutter/material.dart';

import '../../states/vehicle.dart';
import 'dart:math'as math;

class RegPlate extends StatelessWidget {
  const RegPlate({super.key, required this.state});

  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    print(state.toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width/2,
        height: 120,
        child: Card(
          
          color: Colors.white,
          elevation:10,
          // margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(flex: 1,),
               Transform.rotate(angle: -math.pi/2,
               child:Container(
                 width: 100,
                 height: 40,
                  color:Colors.deepOrange,
                  child: Center(child: FittedBox(child: Text('Khyber PakhtoonKhwa'),fit: BoxFit.contain,)),
                ), ),
                
              Spacer(flex: 3,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(state.reg!,
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w400,
                        color: Colors.black)),
                    Text(state.regCity!,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400,
                        color: Colors.black)),
                  ],
                ),
              Spacer(flex: 4,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
