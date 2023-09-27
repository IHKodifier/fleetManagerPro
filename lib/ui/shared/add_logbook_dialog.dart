import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/destination.dart';
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
  TextEditingController destinationNameController = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  String newDestinationName = '';
  DateTime selectedDate = DateTime.now();
  ///formkey for new [Logbook] & new [Destination]
  GlobalKey<FormState> logbookFormKey= GlobalKey<FormState>();
  GlobalKey<FormState> destinationFormKey= GlobalKey<FormState>();
  
  List<Destination> selectedDestinations = [
    //always starts at HF
    // Destination(id: '00001', name: 'HF'),

    //for testing only
  ];

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
        incrementIcon: const Icon(
          Icons.add,
          // size: 35,
          // color: Theme.of(context).colorScheme.primary,
        ),
        decrementIcon: const Icon(
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

  Padding currentReadingRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Current Reading'),
          ),
          const Spacer(
            flex: 3,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(' ${vehicle.driven} '),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Padding driverNameTextField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: const InputDecoration(
            labelText: 'Driver name', hintText: 'optional'),
        controller: destinationNameController,
        // keyboardType: TextInputType.number,
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

  void onAddLogbook() {}

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
            .map((e) => Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ActionChip(
                    avatar: e.name == 'Finish'
                        ? Center(
                            child: Icon(
                              Icons.flag_circle_rounded,
                              color: Colors.red,
                              size: 20,
                            ),
                          )
                        : Container(),
                    label: Text(e.name),
                    onPressed: () {
                      setState(() {
                        selectedDestinations.add(e);
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                ))
            .toList()
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
                    newDestinationName=newValue!;
                  },
                ),
              ),
            ),
            IconButton(
                onPressed: 
                  onCreatreNewDestinationPressed
                ,
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
    destinationFormKey.currentState?.save();
    await FirebaseFirestore.instance.collection('users')
    .doc(
      ref.read(appUserProvider)?.uuid
    )
    .collection('destinations'
    )
    .doc().set({
      'name': newDestinationName,
      // 'id': 
    });

    // ignore: avoid_print
    print(newDestinationName);
  }

  void onCancelNewDestinationPressed() {
    Navigator.pop(context);
  }

  Widget track(Destination e) {
    return Container(
      // width: 124,
      // height: 59,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.keyboard_double_arrow_right,
            size: 24,
            color: Colors.grey,
          ),
          SizedBox(
            width: 4,
          ),
          e.name == 'Finish'
              ? Row(
                children: [
                  Center(
                      child: Icon(
                        Icons.flag_circle_rounded,
                        color: Colors.red,
                        size: 28 ,
                      ),
                    ),
                    Text('Finish'),
                ],
              )
              : ActionChip(label: Text(
                    e.name,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedDestinations.remove(e);
                    });
                  },),]
                   
              
        
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    vehicle = ref.read(currentVehicleProvider);

    final allDestinations = ref.watch(allDestinationsProvider);
    return Dialog(
      child: SingleChildScrollView(
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

            currentReadingRow(),

            Divider(
              indent: 32,
              endIndent: 32,
              height: 20,
              thickness: 0.5,
              color: Theme.of(context).colorScheme.primary,
            ),

            Container(height: 80, child: driverNameTextField()),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                // height: 80,
                child: Card(
                  elevation: 2,
                  child: Wrap(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.flag_circle,
                              size: 35,
                              color: Color.fromARGB(255, 13, 127, 16),
                            ),
                          ),
                          const Text('HF (Start)'),
                        ],
                      ),
                      ...selectedDestinations
                          .map(
                            (e) => track(e),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
            ),

            allDestinations.when(
              loading: onAllDestinationsLoading,
              error: onAllDestinationsError,
              data: onAllDestinationsData,
            ),
            actionsRow(),
            // endReading(context),

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
      ),
    );
  }
}
