import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/destination.dart';
import 'package:fleet_manager_pro/states/logbook.dart';
import 'package:fleet_manager_pro/states/logbook_state.dart';
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
  TextEditingController controller3 = TextEditingController();
  GlobalKey<FormState> destinationFormKey = GlobalKey<FormState>();
  TextEditingController driverNameController = TextEditingController();
  // /formkey for new [Logbook] & new [Destination]
  GlobalKey<FormState> logbookFormKey = GlobalKey<FormState>();

  String newDestinationName = '';
  late Logbook newLogbook;
  DateTime selectedDate = DateTime.now();
  List<Destination> selectedDestinations = [];
  late Vehicle vehicle;

  @override
  void dispose() {
    // TODO: implement dispose
    driverNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    vehicle = ref.read(currentVehicleProvider).copyWith();
    newLogbook = Logbook(id: '199');
  }

  Padding currentReadingRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          const Text('Current Reading'),
          const Spacer(
            flex: 3,
          ),
          Text(
            ' ${vehicle.driven}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 16,
                  // color: Theme.of(context).colorScheme.onSecondary
                ),
          ),
          // const Spacer(),
          const Text(' Km'),
          const Spacer(),
        ],
      ),
    );
  }

  Padding newReadingRow() {
    int newReading = (vehicle.driven! + newLogbook.kmsTravelled).round();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          const Text('New Reading'),
          const Spacer(
            flex: 3,
          ),
          Text(
            ' ${newReading.toString()}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary),
          ),
          // const Spacer(),
          // const Spacer(),
          const Text(' Km'),
          const Spacer(),
        ],
      ),
    );
  }

  Widget driverNameTextField() {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextFormField(
          decoration: const InputDecoration(
              labelText: 'Driver name', hintText: 'optional'),
          controller: driverNameController,
          onSaved: (newValue) {
            newLogbook.driver = newValue!;
          },

          // keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  Padding actionsRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: OutlinedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel'))),
          const SizedBox(
            width: 4,
          ),
          Expanded(
              child: FilledButton.icon(
                  onPressed: onAddLogbook,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'))),
        ],
      ),
    );
  }

  Future<void> onAddLogbook() async {
    if (logbookFormKey.currentState!.validate()) {
      logbookFormKey.currentState!.save();
      newLogbook.destinations = selectedDestinations;
      newLogbook.startReading = vehicle.driven!;
      newLogbook.endReading =
          (vehicle.driven! + newLogbook.kmsTravelled).toInt();
//assign id from db

//get the id
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(ref.read(appUserProvider)!.uuid)
          .collection('vehicles')
          .doc(ref.read(currentVehicleProvider).id)
          .collection('logbook')
          .doc();

//set the id on newLogbook
      newLogbook.id = docRef.id;

// save the doc in Firestore
      await docRef.set(newLogbook.toMap());

//update the driven on parent Vehicle
      ref
          .read(currentVehicleProvider.notifier)
          .updateDriven(newLogbook.endReading.round());

//update the driven on parent firestore doc
      await FirebaseFirestore.instance
          .collection('users')
          .doc(ref.read(appUserProvider)!.uuid)
          .collection('vehicles')
          .doc(ref.read(currentVehicleProvider).id)
          .set(
            ref.read(currentVehicleProvider).toMap(),
            SetOptions(merge: true),
          );
      Navigator.pop(context);

      // int x;
    }
  }

  void onCancel() {
    Navigator.pop(context);
  }

  Widget onAllDestinationsLoading() {
    return const CircularProgressIndicator();
  }

  Widget onAllDestinationsError(Object error, StackTrace stackTrace) {
    return Text(error.toString());
  }

  Widget onAllDestinationsData(List<Destination> data) {
    return Wrap(
      spacing: 2,
      children: [
        IconButton(
          onPressed: createNewDestination,
          icon: Icon(
            Icons.add_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 35,
          ),
        ),
        ...data
            .map((e) => ActionChip(
                  label: Text(e.name),
                  onPressed: () {
                    setState(() {
                      selectedDestinations.add(e);
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ))
            .toList(),
      ],
    );
  }

  OutlinedButton datePickerButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        final DateTime now = DateTime.now();
        final DateTime firstDate =
            DateTime(now.year - 1, now.month, now.day + 1); // 364 days earlier
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
        // style: Theme.of(context)
        //     .textTheme
        //     .titleMedium!
        //     .copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  void createNewDestination() {
    showDialog(context: context, builder: createNewDestinationbuilder);
  }

  Widget createNewDestinationbuilder(BuildContext context) {
    final controller = TextEditingController();
    return Dialog(
      child: Form(
        key: destinationFormKey,
        child: Row(
          children: [
            Expanded(
              // width: 250,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    // label: Text('Create new desintation'),
                    hintText: 'New destination name ',
                  ),
                  onSaved: (newValue) {
                    newDestinationName = newValue!;
                  },
                ),
              ),
            ),
            IconButton(
                onPressed: onCreatreNewDestinationPressed,
                icon: const Icon(Icons.done)),
            IconButton(
                onPressed: onCancelNewDestinationPressed,
                icon: const Icon(Icons.cancel)),
          ],
        ),
      ),
    );
  }

  Future<void> onCreatreNewDestinationPressed() async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(appUserProvider)?.uuid)
        .collection('destinations')
        .doc();

    destinationFormKey.currentState?.save();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(appUserProvider)?.uuid)
        .collection('destinations')
        .doc()
        .set({
      'name': newDestinationName,
      'id': docRef.id,
    });

    // ignore: avoid_print
    print(newDestinationName);
    Navigator.pop(context);
  }

  void onCancelNewDestinationPressed() {
    Navigator.pop(context);
  }

  Widget track(Destination e) {
    return Container(
      // width: 124,
      // height: 59,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Icon(
          Icons.keyboard_double_arrow_right,
          size: 24,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 4,
        ),
        e.name == 'Finish'
            ? const Row(
                children: [
                  Center(
                    child: Icon(
                      Icons.flag_circle_rounded,
                      color: Colors.red,
                      size: 28,
                    ),
                  ),
                  Text('Finish'),
                ],
              )
            : ActionChip(
                label: Text(
                  e.name,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  // maxLines: 2,
                ),
                onPressed: () {
                  setState(() {
                    selectedDestinations.remove(e);
                  });
                },
              ),
      ]),
    );
  }

  Widget tripLength(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(
            indent: 32,
            endIndent: 32,
            // height: 20,
            thickness: 0.5,
            color: Theme.of(context).colorScheme.primary,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Trip Length?',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: SpinBox(
              step: 10,
              textStyle: const TextStyle(fontSize: 20)
                  .copyWith(fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 12),
                suffix: const Text(' Kms'),
                border: const OutlineInputBorder(),
                suffixStyle: const TextStyle(fontSize: 14).copyWith(
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
                contentPadding: const EdgeInsets.all(4),
              ),

              min: 0,
              max: 600,
              value: 0,

              incrementIcon: Icon(
                Icons.add_circle,
                // size: 35,
                color: Theme.of(context).colorScheme.primary,
              ),
              decrementIcon: Icon(
                Icons.remove_circle,
                // size: 35,
                color: Theme.of(context).colorScheme.primary,
              ),
              spacing: 16,
              onChanged: (value) {
                setState(() {
                  // _kmsDriven = value.round();
                  // vehicle.driven = value.round();
                  newLogbook.kmsTravelled = value;
                });
              },
              // showButtons: false,
            ),
          ),
          currentReadingRow(),
          newReadingRow(),
        ],
      ),
    );
  }

  Form logbookForm(
      BuildContext context, AsyncValue<List<Destination>> allDestinations) {
    return Form(
      key: logbookFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Add Log Book',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          datePickerButton(context),
          // currentReadingRow(),
          Divider(
            indent: 32,
            endIndent: 32,
            height: 20,
            thickness: 0.5,
            color: Theme.of(context).colorScheme.primary,
          ),

          // Container(height: 80, child: driverNameTextField()),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              // height: 80,
              child: Wrap(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.flag_circle,
                          size: 45,
                          color: Color.fromARGB(248, 80, 189, 2),
                        ),
                      ),
                      Text(
                        'Start',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  ...selectedDestinations
                      .map(
                        (e) => track(e),
                      )
                      .toList(),
                  selectedDestinations.isNotEmpty
                      ? Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.flag_circle,
                                size: 45,
                                color: Color.fromARGB(255, 235, 55, 19),
                              ),
                            ),
                            Text(
                              'Finish',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: Colors.blueGrey),
                            ),
                          ],
                        )
                      : Container(),
                  Divider(
                    indent: 32,
                    endIndent: 32,
                    // height: 20,
                    thickness: 0.5,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          allDestinations.when(
            loading: onAllDestinationsLoading,
            error: onAllDestinationsError,
            data: onAllDestinationsData,
          ),
          tripLength(context),
          driverNameTextField(),
          actionsRow(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    vehicle = ref.read(currentVehicleProvider).copyWith();
    // newLogbook = Logbook(id: '999');

    final allDestinations = ref.watch(allDestinationsProvider);
    return Dialog(
      child: SingleChildScrollView(
        child: logbookForm(context, allDestinations),
      ),
    );
  }
}
