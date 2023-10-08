import 'package:fleet_manager_pro/states/fuelstop.dart';
import 'package:fleet_manager_pro/utils.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../states/barrel_models.dart';

class FuelStopCard extends StatelessWidget {
  const FuelStopCard({
    super.key,
    required this.state,
    required this.totalDriven,
  });

  final FuelStop state;
  final int totalDriven;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var divider = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Divider(
        thickness: 1.5,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
            width: 1.0, color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FuelStopHeader(state: state),
          ),
          Row(
            children: [
              FuelStopAvatar(totalDriven: totalDriven, state: state),
              SizedBox(
                width: 300,
                child: Column(mainAxisSize: MainAxisSize.min,
                 children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       state.litres.toString(),
                  //       style:
                  //           Theme.of(context).textTheme.titleLarge!.copyWith(
                  //                 fontWeight: FontWeight.w600,
                  //                 fontSize: 28,
                  //               ),
                  //     ),
                  //     const SizedBox(
                  //       width: 2,
                  //     ),
                  //     const Text('L'),
                  //   ],
                  // ),
                  // divider,
                  // Row(
                  //   children: [
                  //     Text(
                  //       state.pricePerLitre.toStringAsFixed(3),
                  //       style:
                  //           Theme.of(context).textTheme.titleLarge!.copyWith(
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 20,
                  //               ),
                  //     ),
                  //     Text(
                  //       '  Rs/L',
                  //       style: Theme.of(context).textTheme.labelSmall,
                  //     ),
                  //   ],
                  // ),

                  // divider,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Divider(thickness: 3,
                      // color: Colors.black,),
                    
                      Text(
                        'Total',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                                fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 40),
                      // Spacer(),
                      Text(
                        'Rs ',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              // fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              // fontSize: 20,
                            ),
                      ), 
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Text(
                          Utils.thousandify(state.totalCost.toInt()),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge 
                              ?.copyWith(
                                  fontSize: 42, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FuelStopHeader extends StatelessWidget {
  const FuelStopHeader({super.key, required this.state});

  final FuelStop state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [ 
        const Spacer(flex: 2,),
         Icon(
          Icons.local_gas_station_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 45,
        ),
        Text(
          state.litres.toString(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 28,
              ),
        ),
        const SizedBox(
          width: 2,
        ),
        const Text('L'),
        const Spacer(
          flex: 3,
        ),
         Text(' @ Rs ',
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                // fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                // fontSize: 20,
              ),
        ),
         Text('${
          state.pricePerLitre.toStringAsFixed(3)}',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
        ),
        Text(
          ' /L',
          style: Theme.of(context).textTheme.labelSmall,
        ),
    
        const Spacer(flex: 2,),
        Text(
          timeago.format(DateTime.fromMillisecondsSinceEpoch(
              state.timestamp.millisecondsSinceEpoch)),
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const Spacer(flex: 1,),
      ],
    );
  }
}

class FuelStopAvatar extends StatelessWidget {
  const FuelStopAvatar(
      {super.key, required this.state, required this.totalDriven});

  final FuelStop state;
  final int totalDriven;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 35,
            child: Text((totalDriven - state.driven).toString()),
          ),
        ),
        const Text('Kms ago'),
      ],
    );
  }
}
