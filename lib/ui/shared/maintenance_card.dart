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
            child: MaintenanceHeader(state: state),
          ),
          Row(
            children: [
              MaintenanceAvatar(totalDriven: totalDriven, state: state),
              SizedBox(
                width: 260, 
                // constraints: BoxConstraints(minHeight: 120),
                // height: 120,
                //  color: Colors.green,
                child: Card(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text(e!.name)),
                                    // SizedBox(width: 150),
                                    // const Spacer(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(Utils.thousandify(e.cost)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        // Spacer(),
                        // SizedBox(height: 6,),
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
                          
                            Text(
                              'Total',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
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
                                    ?.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
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

class MaintenanceHeader extends StatelessWidget {
  const MaintenanceHeader({super.key, required this.state});

  final Maintenance state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        Text(
          state.location!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        Text(
          '${timeago.format(state.timestamp!)} ',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

class MaintenanceAvatar extends StatelessWidget {
  const MaintenanceAvatar(
      {super.key, required this.state, required this.totalDriven});

  final Maintenance state;
  final int totalDriven;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 35,
            child: Text((totalDriven - state.kmsDriven).toString()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: const Text('Kms ago'),
        ),
      ],
    );
  }
}
