import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../states/barrel_models.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../utils.dart';

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


    // return LayoutBuilder(builder: (context, constraints) 
    // // {
    //   minHeight = constraints.minHeight;
    //   minWwidth = constraints.minWidth;
    //   maxHeight = constraints.maxHeight;
    //   maxWwidth = constraints.maxWidth;
      return IntrinsicHeight(
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Container(
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
                                  style: Theme.of(context).textTheme.displayLarge,
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
      
                Flexible(
                  
                  child: Stack(
                    clipBehavior: Clip.antiAlias,
                    children: [
                      buildMaintenanceLocationText(context),
                      buildTimeAgoText(context),
                      buildServicesTable(context)
                    ],
                  ),
                ),
      
                // Text('max Height = ${maxHeight.toString()}'),
                // Text('min Width = ${minWwidth.toString()}'),
                // Text('max Height = ${maxWwidth.toString()}'),
              ],
            ),
          ),
        ),
      );
    // },
    // );
  }

  Positioned buildServicesTable(BuildContext context) {
    return Positioned(
                      top: 50,
                      left: 8,
                      // child: Container(color: Colors.teal,
                      width: 270,
                      // height: do
                      child: Flex(
                          // shrinkWrap: true,
                          
                          direction: Axis.vertical,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ...state.services!
                                .map(
                                  (e) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(e!.name),
                                      // SizedBox(width: 150),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0),
                                        child: Text(e.cost.toString()),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                            // Spacer(),
                            // SizedBox(height: 6,),
                                    
                            totalsRow(context),
                                      SizedBox(height: 12,),
                          ]
                          )
                          );
  }

  Positioned buildTimeAgoText(BuildContext context) {
    return Positioned(
                    top: 8,
                    right: 8,
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
                    child: Text(
                      state.location!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
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
      padding: EdgeInsets.all(4),
      decoration: buildLeadingDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Spacer(),
            // Text(Utils.thousandify(totalDriven-maintenance.kmsDriven),style: Theme.of(context).textTheme.headlineSmall),
            const Text(
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
              ?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        SizedBox(width: 20),
        // Spacer(),

        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            state.cost.toString(),
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
