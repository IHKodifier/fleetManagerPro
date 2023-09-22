import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/destination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:intl/intl.dart';

class AddLogbookDialog extends ConsumerStatefulWidget {
  const AddLogbookDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddLogbookDialogState();
}

class _AddLogbookDialogState extends ConsumerState<AddLogbookDialog> {
  List<Destination> allDestinations = []; // Fetch this from Firestore
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late Vehicle vehicle;

  Widget endReading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: SpinBox(
        step: 10,
        // textStyle: const TextStyle(fontSize: 20)
        //     .copyWith(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: 'End Reading',
          // labelStyle:
          //     Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 10),
          suffix: const Text(' Kms'),
          border: const OutlineInputBorder(),
          suffixStyle: const TextStyle(fontSize: 14).copyWith(
              fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
          contentPadding: const EdgeInsets.all(4),
        ),
        // textAlign: TextAlign.center,
        // min: _rangeStart!.toDouble(),
        min: 102.3,
        max: 500000,
        // value: _kmsDriven!.toDouble(),
        value: 856,
        // iconSize: 45,
        // textStyle: Theme.of(context)
        //     .textTheme
        //     .displaySmall!
        //     .copyWith(fontSize: 16),
        incrementIcon: Icon(
          Icons.add,
          // size: 35,
          // color: Theme.of(context).colorScheme.primary,
        ),
        decrementIcon: Icon(
          Icons.remove,
          // size: 35,
          // color: Theme.of(context).colorScheme.primary,
        ),
        spacing: 16,
        onChanged: (value) {
          setState(() {
            // _kmsDriven = value.round();
          });
        },
        // showButtons: false,
      ),
    );
  }

  Stream<List<Destination>> allDestinationsStream() =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(ref.read(appUserProvider)!.uuid)
          .collection('destinations')
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Destination.fromMap(e.data())).toList());

  @override
  Widget build(BuildContext context) {
    vehicle = ref.read(currentVehicleProvider);
    //  allDestinations=

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Add Log Book',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              final DateTime now = DateTime.now();
              final DateTime firstDate = DateTime(
                  now.year - 1, now.month, now.day + 1); // 364 days earlier
              final DateTime lastDate =
                  DateTime(now.year, now.month, now.day + 6); // 7 days later

              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: firstDate,
                lastDate: lastDate,
              );
              if (picked != null && picked != selectedDate) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
            child: Text(
              DateFormat('EEE, dd  MMM  yyyy').format(selectedDate),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
Padding(
  padding: const EdgeInsets.symmetric(vertical:8.0),
  child:   Row(
  
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  
    children: [
  
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Current Reading'),
          ),
  
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(' ${vehicle.driven} '),
          ),
  
    ],
  
  ),
),
          endReading(context),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Current Reading ',
                hintText: 'hint text',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              ),
              controller: controller1,
              keyboardType: TextInputType.number,
            ),
          ),
          TextField(
            controller: controller2,
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: controller3,
            keyboardType: TextInputType.number,
          ),
          // Wrap(
          //   children: allDestinationsStream.map((destination) {
          //     return ChoiceChip(
          //       label: Text(destination),
          //       selected: false, // Update this based on your logic
          //       onSelected: (bool selected) {
          //         // Handle your logic here
          //       },
          //     );
          //   }).toList(),
          // ),
        ],
      ),
    );
  }
}
