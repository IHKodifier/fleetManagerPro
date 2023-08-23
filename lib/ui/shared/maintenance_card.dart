import 'package:fleet_manager_pro/utils.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../states/barrel_models.dart';

class MaintenanceCard extends StatelessWidget {
  const MaintenanceCard({
    super.key,
    required this.state,
    required this.totalDriven,
  });

  final Maintenance state;
  final int totalDriven;

  @override
  Widget build(BuildContext context) {
  
    return IntrinsicHeight(
      child: 
           _maintenanceCard(context)
    );
    // },
    // );
  }

  Card _maintenanceCard(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            IntrinsicHeight(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.onPrimary,
                      ]),
                ),
                width: 92,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                '${totalDriven - state.kmsDriven}',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(
                                child: Text(
                                  'Km ago ',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Flexible(
              child: Column(
                // clipBehavior: Clip.antiAlias,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      Icon(
                        Icons.car_repair,
                        color: Theme.of(context).colorScheme.primary,
                        size: 70, 
                      ),
                      const Spacer(),
                      // buildMaintenanceLocationText(context),
                      const Spacer(),
                    ],
                  ),
                  // buildTimeAgoText(context),
                  // buildServicesTable(context)
                ],
              ),
            ),

            //
          ],
        ),
      ),
    );
  }

  Card _fuelstopCard(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            IntrinsicHeight(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.onPrimary,
                      ]),
                ),
                width: 92,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                '${totalDriven - state.kmsDriven}',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FittedBox(
                                child: Text(
                                  'Km ago ',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // clipBehavior: Clip.antiAlias,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // buildTimeAgoText(context),

                  // buildMaintenanceLocationText(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        state.litres.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        'L ',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: Colors.blueGrey.shade800),
                      ),
             
                      Text(
                        '@ ',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: Colors.blueGrey.shade800),
                      ),
                      Text(Utils.thousandify(state.cost!~/state.litres!),
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(
                        width: 4,
                      ),
                      Text('Rs/L',
                      style: Theme.of(context).textTheme.labelSmall,),
                    ],
                  ),
                  // buildServicesTable(context)
                ],
              ),
            ),

            // Text('max Height = ${maxHeight.toString()}'),
            // Text('min Width = ${minWwidth.toString()}'),
            // Text('max Height = ${maxWwidth.toString()}'),
          ],
        ),
      ),
    );
  }

  Positioned buildServicesTable(BuildContext context) {
    return Positioned(
        top: 50,
        left: 80,

        // child: Container(color: Colors.teal,
        width: 270,
        // height: do
        child: Card(
          // color: Colors.white54,
          elevation: 5,
          margin: const EdgeInsets.all(4),
          child: Column(
              // shrinkWrap: true,

              // direction: Axis.vertical,
              mainAxisSize: MainAxisSize.max,
              children: [
                ...state.services!
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 2, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(e!.name)),
                            // SizedBox(width: 150),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(Utils.thousandify(e.cost)),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                // Spacer(),
                // SizedBox(height: 6,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    thickness: 1.5,
                    color: Colors.black87,
                  ),
                ),
                totalsRow(context),
                const SizedBox(
                  height: 4,
                ),
              ]),
        ));
  }

  Positioned buildTimeAgoText(BuildContext context) {
    return Positioned(
      // top: 8,
      // right: 8,
      child: Text(
        '${timeago.format(state.timestamp!)} ',
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  Positioned buildMaintenanceLocationText(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      child: state.location != 'Fuel Station 1'
          ? Text(
              state.location!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            )
          : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Icon(
                  Icons.local_gas_station,
                  size: 70,
                  color: Theme.of(context).colorScheme.primary,
                ),
              const Spacer(),
                Text(
                  Utils.thousandify(state.cost!),
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                // SizedBox(
                //   width: 4,
                // ),
                Text(
                  'Rs ',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.blueGrey.shade800),
                ),
              const Spacer(),
            ],
          ),
    );
  }

  Column buildLeadingWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildLeadingText(context),
      ],
    );
  }

  Container buildLeadingText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: buildLeadingDecoration(context),
      child: const Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Spacer(),
            // Text(Utils.thousandify(totalDriven-maintenance.kmsDriven),style: Theme.of(context).textTheme.headlineSmall),
            Text(
              'Kms ago',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
            // Spacer(),
          ],
        ),
      ),
    );
  }

  BoxDecoration buildLeadingDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.onPrimary,
            Theme.of(context).colorScheme.secondary,
          ]),
      border: Border.all(
        color: Theme.of(context).colorScheme.onSecondary,
        width: 0.75,
      ),
    );
  }

  totalsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Divider(thickness: 3,
        // color: Colors.black,),
        Text(
          'Total',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 40),
        // Spacer(),

        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Text(
            Utils.thousandify(state.cost!),
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
