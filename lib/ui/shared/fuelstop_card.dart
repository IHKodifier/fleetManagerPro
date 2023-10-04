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
                child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(4),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(state.litres.toString(),style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),),
                        SizedBox(width: 4 ,),
                        Text('Ltr    @      Rs '), 
                         Text(
                          state.pricePerLitre.toStringAsFixed(4),
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                  ),
                        ),
                      ],
                    ),
                    // Text('${}), Ltr  @ Rs ${state.pricePerLitre.toStringAsFixed(3)}'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Divider(
                        thickness: 1.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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

                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Text(
                            Utils.thousandify(state.totalCost.toInt()),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                  ]),
                ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(flex: 4,),
        Icon(Icons.local_gas_station_rounded,size: 40,),
        const Spacer(flex: 1,),
        Text(
          // state.location!, 
          'Fuel Stop',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(flex: 3,),
        Text(
          timeago.format(DateTime.fromMillisecondsSinceEpoch(
              state.timestamp.millisecondsSinceEpoch)),
          style: Theme.of(context).textTheme.labelSmall,
        ),
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
        CircleAvatar(
          radius: 35,
          child: Text((totalDriven - state.driven).toString()),
        ),
        const Text('Kms ago'),
      ],
    );
  }
}
