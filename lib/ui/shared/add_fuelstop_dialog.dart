// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/states/fuelstop.dart';
import 'package:fleet_manager_pro/ui/screens/vehicle_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import '../../states/barrel_models.dart';
import '../../states/vehicle_state.dart';

class AddFuelStopDialog extends ConsumerStatefulWidget {
  const AddFuelStopDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddFuelStopDialogState();
}

class _AddFuelStopDialogState extends ConsumerState<AddFuelStopDialog> {
  double costPerLitre = 0;
  bool isBusy = false;
  double litres = 0, cost = 0;
  int? newDriven = 0;
  int oldDriven = 0;

  addFuelStopForm() {
    oldDriven = ref.read(currentVehicleProvider).driven!;
    costPerLitre = cost / litres;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SpinBox(
            incrementIcon: Icon(
              Icons.add_circle,
              color: Theme.of(context).colorScheme.primary,
              // size: 30,
            ),
            decrementIcon: Icon(
              Icons.remove_circle,
              color: Theme.of(context).colorScheme.primary,
              // size: 30,
            ),
            max: double.infinity,
            value: cost,
            step: 100,
            decoration: InputDecoration(
              hintText: 'Hint',
              labelText: 'TOTAL PRICE ',
              labelStyle:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
              suffix: const Text('Rs'),
              border: const OutlineInputBorder(),
              suffixStyle: const TextStyle(fontSize: 14).copyWith(
                  fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
              contentPadding: const EdgeInsets.all(16),
            ),
            onChanged: (value) => setState(() {
              cost = value;
            }),
          ),
          const SizedBox(
            height: 8,
          ),
          SpinBox(
            min: 0,
            max: double.infinity,
            incrementIcon: Icon(
              Icons.add_circle, color: Theme.of(context).colorScheme.primary,
              // size: 35,
            ),
            decrementIcon: Icon(
              Icons.remove_circle, color: Theme.of(context).colorScheme.primary,
              // size: 35,
            ),
            value: litres,
            step: 1.11,
            decimals: 1,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            decoration: InputDecoration(
              labelText: 'Litres',
              labelStyle:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
              suffix: const Text('Ltr.'),
              border: const OutlineInputBorder(),
              suffixStyle: const TextStyle(fontSize: 14).copyWith(
                  fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
              contentPadding: const EdgeInsets.all(16),
            ),
            onChanged: (value) => setState(() {
              litres = value * 1.0;
            }),
          ),
          const SizedBox(
            height: 6,
          ),
          (cost != 0 && litres != 0)
              ? Text('@  Rs. ${costPerLitre.toStringAsFixed(3)} /Ltr')
              : Container(),
          const SizedBox(
            height: 6,
          ),
          SpinBox(
            incrementIcon: Icon(
              Icons.add_circle,
              color: Theme.of(context).colorScheme.primary,
              // size: 35,
            ),
            decrementIcon: Icon(
              Icons.remove_circle,
              color: Theme.of(context).colorScheme.primary,
              // size: 35,
            ),
            keyboardType: const TextInputType.numberWithOptions(),
            min: oldDriven.toDouble(),
            max: double.infinity,
            // decimals: true,
            step: 10,

            value:
                newDriven != 0 ? newDriven!.toDouble() : oldDriven.toDouble(),
            onChanged: (value) => setState(() {
              newDriven = value.round();
            }),
            decoration: InputDecoration(
              hintText: 'Hint',
              labelText: 'Kilometers Driven',
              labelStyle:
                  Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
              suffix: const Text('Kms'),
              border: const OutlineInputBorder(),
              suffixStyle: const TextStyle(fontSize: 14).copyWith(
                  fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveFuelStop() async {
    setState(() {
      isBusy = true;
    });
    final vehicle = ref.read(currentVehicleProvider);

    //get the id for newFuelStop
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(appUserProvider)!.uuid)
        .collection('vehicles')
        .doc(vehicle.id)
        .collection('fuelstops')
        .doc();
    // create the newFuelStop instance
    final newFuelStop = FuelStop(
        id: docRef.id,
        driven: newDriven!.toInt(),
        litres: litres,
        totalCost: cost);
    //save the doc to Firbase
    await docRef.set(newFuelStop.toMap());
    //update the [driven]on parent Vehicle Firebase Doc

    ref.read(currentVehicleProvider.notifier).updateDriven(newDriven!);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(appUserProvider)?.uuid)
        .collection('vehicles')
        .doc(ref.read(currentVehicleProvider).id)
        .set({'driven': newDriven}, SetOptions(merge: true));
    setState(() {
      isBusy = false;
    });
    //  ref.invalidate(currentVehicleProvider);
     Navigator.pop(context);
    //  ref.refresh(currentVehicleProvider);
     Navigator.pushReplacement(context, MaterialPageRoute(builder:  (context) => const VehicleDetailScreen()));
    //  Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        Icons.local_gas_station,
        size: 50,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('Add Fuel Stop'),
      content: addFuelStopForm(),
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.all(8),
      actionsOverflowButtonSpacing: 10,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: FilledButton.icon(
                onPressed: saveFuelStop,
                icon: const Icon(Icons.save),
                label: isBusy
                    ? const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
