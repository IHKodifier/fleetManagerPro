import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import '../../states/barrel_models.dart';
import '../../states/vehicle_state.dart';

class AddFuelStopDialog extends ConsumerStatefulWidget {
  const AddFuelStopDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddFuelStopDialogState();
}

class _AddFuelStopDialogState extends ConsumerState<AddFuelStopDialog> {
  double litres = 0, cost = 0;
  int oldDriven = 0;
  int? newDriven = 0;
  double costPerLitre = 0;
  bool isBusy=false;
 
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          icon: Icon(Icons.local_gas_station,size: 50,),
          title: Text('Add Fuel Stop'),
          content: addFuelStopForm(),
          actionsAlignment: MainAxisAlignment.end,
          actionsPadding: EdgeInsets.all(8),
          actionsOverflowButtonSpacing: 10,
          actionsOverflowAlignment: OverflowBarAlignment.center,
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {Navigator.pop(context);},
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: saveFuelStop,
                    icon: Icon(Icons.save),
                    label: isBusy? CircularProgressIndicator(): Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        );
  }
  
  addFuelStopForm() {
    oldDriven = ref.read(currentVehicleProvider).driven!;
    costPerLitre = cost / litres;
     return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SpinBox(
          min: 0,
          max: double.infinity,
          value: cost,
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
          value: litres,
          decimals: 2,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          decoration: InputDecoration(
            labelText: 'Litres',
            labelStyle:
                Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
            suffix: const Text('Ltr.'),
            // keyboardType:
            border: const OutlineInputBorder(),
            suffixStyle: const TextStyle(fontSize: 14).copyWith(
                fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: (value) => setState(() {
            litres = value;
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
          min: oldDriven.toDouble(),
          max: double.infinity,
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
    );
  }

  Future<void> saveFuelStop() async {
    setState(() {
      isBusy=true;
    });
     
    final vehicle= ref.read(currentVehicleProvider);
    final  fuelStop = Maintenance(cost:cost.toInt(),
    services: [Service(name: 'Fuel',cost: cost.round())],
    timestamp: DateTime.now(),
    location: 'Fuel Station 1'
     );
     fuelStop.kmsDriven= newDriven!.toInt();
     DocumentReference  docRef = FirebaseFirestore.instance
     .collection('users')
     .doc(ref.read(appUserProvider)!.uuid)
     .collection('vehicles')
     .doc(vehicle.id).collection('maintenances').doc();
     fuelStop.id=docRef.id;
     await docRef.set(fuelStop.toMap());
     await FirebaseFirestore.instance.collection('users').doc(ref.read(appUserProvider)?.uuid).collection('vehicles').doc(ref.read(currentVehicleProvider).id).set({'driven':newDriven},SetOptions(merge: true));
     Navigator.pop(context);
     Navigator.pop(context);

  }
}

