import 'dart:math';

import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/service_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../states/maintenances.dart';
import '../shared/service_edit_form.dart';
import '../shared/valu_indicator_dlidershape.dart';

class AddMaintenanceScreen extends ConsumerStatefulWidget {
  const AddMaintenanceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      AddMaintenanceScreenState();
}

class AddMaintenanceScreenState extends ConsumerState<AddMaintenanceScreen> {
  late Maintenance newMaintenanceState;
  late Service newService;
  late Vehicle vehicleState;

  final _addServiceFormKey = GlobalKey<FormState>();
  int? _cost;
  final _formKey = GlobalKey<FormState>();
  String? _id;
  int? _kmsDriven;
  String? _location;
  int? _rangeStart;
  final TextEditingController _serviceCostController = TextEditingController();
  final TextEditingController _serviceNameController = TextEditingController();
  MaintenanceType? _type;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vehicleState = ref.read(currentVehicleProvider);
    newMaintenanceState = Maintenance();
    _kmsDriven = vehicleState.driven;
    _rangeStart = _kmsDriven!;
    _cost = 0;
  }

  void onAddServicePressed() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Add new Service'),
              content: Form(
                  key: _addServiceFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        onSaved: (newValue) {
                          newService = Service(name: newValue!);
                        },
                        controller: _serviceNameController,
                        decoration: const InputDecoration(
                            label: Text('Name'),
                            hintText: 'example:  brake pads replacement'),
                      ),
                      TextFormField(
                        controller: _serviceCostController,
                        onSaved: (newValue) =>
                            newService.cost = int.tryParse(newValue!)!,
                        decoration: const InputDecoration(
                            label: Text('Cost'), hintText: 'example:4,500 Rs'),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          TextButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.cancel),
                              label: const Text('Cancel')),
                          const Spacer(),
                          ElevatedButton.icon(
                              onPressed: onSaveService,
                              icon: const Icon(Icons.save),
                              label: const Text('Save')),
                        ],
                      )
                    ],
                  )),
            ));
  }

  Future<void> onSaveService() async {
    if (!_addServiceFormKey.currentState!.validate()) {
      return;
    }
    _addServiceFormKey.currentState?.save();
    var data = newService.toMap();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(appUserProvider)?.uuid)
        .collection('services')
        .add(newService.toMap());
    // print(_formKey.currentState.toString());
    ref.invalidate(allServicesProvider);
    _serviceNameController.dispose();
    _serviceCostController.dispose();
    Navigator.pop(context);
  }

  void onLocationsDropdownChanged(value) => setState(() {
        newMaintenanceState.location = value;
        _location = value;
      });

  void _submitAddMaintenanceForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();

      newMaintenanceState.timestamp = DateTime.now();
      newMaintenanceState.location = _location;
      newMaintenanceState.cost = _cost;
      newMaintenanceState.kmsDriven = _kmsDriven!;
      newMaintenanceState.services = ref.read(selectedServicesProvider);
      var formatter = NumberFormat('#,##,000');

      //TODO save to proper collection path and create a function for it
      final user = ref.read(appUserProvider);
      final Vehicle vehicle = ref.read(currentVehicleProvider);
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uuid)
          .collection('vehicles')
          .doc(vehicle.id)
          .collection('maintenances')
          .doc();
      newMaintenanceState.id = docRef.id;

      docRef
          .set(newMaintenanceState.toMap())
          // .add(newMaintenanceState.toMap())
          .then((value) async {
        //TODO dispose controllers
        ref.invalidate(selectedServicesProvider);
        //todo update [driven] on vehicle objet
        // ref.read(currentVehicleProvider.notifier).updateDriven(_kmsDriven!);
        FirebaseFirestore.instance
            .collection('users')
            .doc(ref.read(appUserProvider)?.uuid)
            .collection('vehicles')
            .doc(ref.read(currentVehicleProvider).id)
            .set({'driven': _kmsDriven}, SetOptions(merge: true)).then((value) {
          Navigator.pop(context);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedServices = ref.watch(selectedServicesProvider);
    final locationStreamAsyncValue = ref.watch(locationStreamProvider);
    newMaintenanceState = Maintenance();
    final vehicleState = ref.read(currentVehicleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Maintenance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              locationStreamAsyncValue.when(
                data: (locations) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SizedBox(
                      // width: double.infinity,
                      child: DropdownButton(
                        hint: Text('select location'),
                        value: _location,
                        isExpanded: true,
                        items: locations.map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (selectedLocation) {
                          //todo Handle the selected location
                          setState(() {
                            newMaintenanceState.location = selectedLocation;
                            _location = selectedLocation;
                          });
                        },
                      ),
                    ),
                  );
                },
                loading: () {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                error: (error, stackTrace) {
                  return Text('Error loading locations: $error');
                },
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer(),
                  Text(_kmsDriven.toString(),
                      style: Theme.of(context).textTheme.displayMedium),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Kms',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),

              // Slider(
              //   // theme
              //   value: _kmsDriven!.toDouble(),
              //   min: _rangeStart!.toDouble(),
              //   label: _kmsDriven?.round().toString(),
              //   max: _rangeStart!<100000.0?120000.0:250000.0,
              //   // divisions: 10,
              //   onChanged: (value) {
              //     setState(() {
              //       _kmsDriven = value.round();
              //     });
              //   },
              // ),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: ValueIndicatorThumbShape(
                    minValue: _rangeStart!.toDouble(),
                    maxValue: _rangeStart! < 100000.0 ? 120000.0 : 250000.0,
                  ),
                  // Other properties...
                ),
                child: Slider(
                  value: _kmsDriven!.toDouble(),
                  min: _rangeStart!.toDouble(),
                  max: _rangeStart! < 100000.0 ? 120000.0 : 250000.0,
                  onChanged: (value) {
                    setState(() {
                      _kmsDriven = value.round();
                    });
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(' cost'),
                  Spacer(
                    flex: 1,
                  ),
                  //todo get maintenance cost from state
                  Text(
                    _cost.toString(),
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  // Spacer(flex: 1,),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Rs',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Consumer(
                builder: (context, watch, _) {
                  final allServices = ref.watch(allServicesProvider);
                  final selectedServices = ref.watch(selectedServicesProvider);

                  return allServices.when(
                    data: (services) {
                      return Card(
                        // color: Colors.transparent,
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                          child: Wrap(
                            spacing: 4,
                            alignment: WrapAlignment.center,
                            runSpacing: 4,
                            children: [
                              // SizedBox(height:20 ),
                              OutlinedButton(
                                onPressed: onAddServicePressed,
                                child: const Icon(
                                  Icons.add,
                                  size: 40,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),

                              ...services.map((service) {
                                final isSelected =
                                    selectedServices.contains(service);
                                return GestureDetector(
                                  onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text('Edit Service'),
                                              // icon: Icon(Icons.edit),
                                              scrollable: true,
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  ServiceEditForm(
                                                    name: service.name,
                                                    cost: service.cost,
                                                    userUUId: ref
                                                        .read(appUserProvider)!
                                                        .uuid,
                                                  ),
                                                ],
                                              ),
                                            ));
                                  },
                                  child: ChoiceChip(
                                    label: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          service.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Rs ${service.cost.toString()} ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                  color: Colors.black54,
                                                  fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    selected: isSelected,
                                    onSelected: (isSelected) {
                                      final selectedServicesNotifier =
                                          ref.watch(selectedServicesProvider
                                              .notifier);
                                      if (isSelected) {
                                        selectedServicesNotifier.add(service);
                                        setState(() {
                                          _cost = (_cost! + service.cost);
                                        });

                                        print(
                                            '${service.name} has been selected');
                                      } else {
                                        selectedServicesNotifier
                                            .remove(service);
                                        setState(() {
                                          _cost = _cost! - service.cost;
                                        });

                                        print(
                                            '${service.name} has been UN-selected');
                                      }
                                    },
                                  ),
                                );
                              }).toList()
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Text('Error: $error'),
                  );
                },
              ),
              ElevatedButton(
                onPressed: _submitAddMaintenanceForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
