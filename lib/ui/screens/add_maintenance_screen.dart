import 'dart:math';

import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/service_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/maintenances.dart';
import '../shared/service_chip.dart';

class ServicesWidget {
  final String name;
  late final int cost;

  ServicesWidget({required this.name, required this.cost});
}

class AddMaintenanceScreen extends ConsumerStatefulWidget {
  const AddMaintenanceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      AddMaintenanceScreenState();

  //
}

class AddMaintenanceScreenState extends ConsumerState<AddMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addServiceFormKey = GlobalKey<FormState>();
      late  Service newService;

  final TextEditingController _locationController=TextEditingController();
  final TextEditingController _serviceNameController=TextEditingController();
  final TextEditingController _serviceCostController=TextEditingController();
  String? _id;
  String? _location;
  Timestamp? _timestamp;
  MaintenanceType? _type;
  int? _kmsDriven;
  int? _cost;
  // List<Service?>? _services;
  // late AsyncValue<Set<Service>> selectedServices= ref.watch(selectedServicesProvider );

  void _submitForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      final newMaintenance = {
        'id': _id,
        'location': _location,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'type': _type.toString(),
        'kmsDriven': _kmsDriven,
        'cost': _cost,
        // 'services': _services,
      };
      FirebaseFirestore.instance
          .collection('maintenances')
          .add(newMaintenance)
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedServices = ref.watch(selectedServicesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Add Maintenance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                onSaved: (value) => _location = value,
              ),
              Slider(value: 50, min: 0, max: 100, onChanged: onSliderChanged),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.number,
                onSaved: (value) => int.tryParse(value!),
              ),
              Consumer(
                builder: (context, watch, _) {
                  final allServices = ref.watch(allServicesProvider);
                  final selectedServices =
                      ref.watch(selectedServicesProvider.notifier);

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

                              Container(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    OutlinedButton(
                                      onPressed: onAddServicePressed,
                                      child: const Icon(Icons.add,size: 40,),
                                    ),
                                    const Spacer(),
                                    OutlinedButton(
                                      onPressed: onEditServicePressed,
                                      child: const Icon(Icons.edit_note,size: 40,),
                                    ),
                                  ],
                                ),
                              ),
                              ...services.map((service) {
                                final isSelected =
                                    selectedServices.state.contains(service);
                                return ChoiceChip(
                                  label: Text(service.name),
                                  selected: isSelected,
                                  onSelected: (isSelected) {
                                    final selectedServicesNotifier = ref.watch(
                                        selectedServicesProvider.notifier);
                                    if (isSelected) {
                                      selectedServicesNotifier.add(service);
                                      print(
                                          '${service.name} has been selected');
                                    } else {
                                      selectedServicesNotifier.remove(service);
                                      print(
                                          '${service.name} has been UN-selected');
                                    }
                                  },
                                );
                              }).toList()
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Text('Error: $error'),
                  );
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSliderChanged(double value) {
    setState(() {
      
    });
  }

  void _addService() {}

  void onAddServicePressed() {
    showDialog(context: context, builder: (_)=>AlertDialog(title: const Text('Add new Service'),
    content: Form(
      key: _addServiceFormKey,
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          onSaved: (newValue) {
            newService= Service(name: newValue!);
          },
          controller: _serviceNameController,
          decoration: const InputDecoration(
            label: Text('Name'),
            hintText: 'example:  brake pads replacement'
          ),
        ),
        TextFormField(
          controller: _serviceCostController,
          onSaved: (newValue) => newService.cost = int.tryParse(newValue!)!,
          decoration: const InputDecoration(
            label: Text('Cost'),
            hintText: 'example:4,500 Rs'
          ),
        ),
      const SizedBox(height: 12,),
        Row(
          children: [
            TextButton.icon(onPressed:  ()=>Navigator.pop(context), icon: const Icon(Icons.cancel), label: const Text('Cancel')),
            const Spacer(),
            ElevatedButton.icon(onPressed:onSaveService, icon: const Icon(Icons.save), label: const Text('Save')),
          ],
        )
        
      ],)),));
  }

  void onEditServicePressed() {
  }

  Future<void> onSaveService() async {
    if(!_addServiceFormKey.currentState!.validate()){
      return ;
    }
    _addServiceFormKey.currentState?.save();
    var data = newService.toMap();
    await FirebaseFirestore.instance.collection('users').doc(ref.read(appUserProvider)?.uuid).collection('services').add(newService.toMap());
    // print(_formKey.currentState.toString());
    ref.invalidate(allServicesProvider);
    Navigator.pop(context);

  }
}
