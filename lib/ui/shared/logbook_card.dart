import 'package:fleet_manager_pro/states/logbook.dart';
import 'package:fleet_manager_pro/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogbookCard extends StatelessWidget {
  const LogbookCard({super.key, required this.state});

  final Logbook state;

  Widget dateBuilder(BuildContext context) {
    return Text.rich(TextSpan(
      style: Theme.of(context).textTheme.titleMedium,
      text: DateFormat('E , ').format(state.timestamp.toDate()),
      children: [
        TextSpan(
            text: DateFormat('dd').format(state.timestamp.toDate()),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
        TextSpan(
            text: DateFormat(' MMM ').format(state.timestamp.toDate()),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
        TextSpan(
          text: DateFormat('yyy').format(state.timestamp.toDate()),
          // style: Theme.of(context).textTheme.titleLarge?.copyWith(
          //   fontSize: 32,
          //   fontWeight: FontWeight.bold
          // ),
        ),
     state.driver.isNotEmpty?TextSpan(
      text: ' (${state.driver})',
     style: Theme.of(context).textTheme.labelMedium
      ):TextSpan(text: ' ( Default Driver)',
           style: Theme.of(context).textTheme.labelMedium),
      ],
    ));
  }

  Row titleBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        dateBuilder(context),
      ],
    );
  }

  Row readingsRowBuilder(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Start Reading: ',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(Utils.thousandify(state.startReading),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary)),
                ],
              ),
              Row(
                children: [
                  Text(
                    'End Reading: ',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(Utils.thousandify(state.endReading),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1.0,
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            titleBuilder(context),
            readingsRowBuilder(context),
            thisTripBuilder(context),
            Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              spacing: 0,
              children: [

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.flag_circle_sharp,color: Colors.green),
                ),
               
               
                ...state.destinations.map((e) => Padding(
                  padding: const EdgeInsets.all(4),
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    type: MaterialType.card,
                    elevation:1,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(e.name),
                    )),
                )).toList(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.flag_circle_sharp,color: Colors.red),
                                  ),

              ],
            ),

          ],
        ),
      ),
    );
  }

  Row thisTripBuilder(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('This trip:',
               style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(' ${state.kmsTravelled} Km',
               style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary),),
            ],
          );
  }
}
