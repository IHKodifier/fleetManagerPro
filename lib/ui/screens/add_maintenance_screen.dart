import 'package:fleet_manager_pro/states/service_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/maintenances.dart';
import '../shared/service_chip.dart';



class Service {
  final String name;
  final int cost;

  Service({required this.name, required this.cost});
}

class AddMaintenanceScreen extends ConsumerStatefulWidget {
  const AddMaintenanceScreen({Key? key}) : super(key: key);
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AddMaintenanceScreenState();

  //
}

class AddMaintenanceScreenState extends ConsumerState<AddMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
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
    final selectedServices= ref.watch(selectedServicesProvider) ;
    return Scaffold(
      appBar: AppBar(title: Text('Add Maintenance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
             
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                onSaved: (value) => _location = value,
              ),
           
              
              
             Slider(value: 50,
             min: 0,
             max: 100, onChanged: onSliderChanged),
             
             
             
              TextFormField(
                decoration: InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.number,
                onSaved: (value) => int.tryParse(value!),
              ),
            

            Consumer(
  builder: (context, watch, _) {
    final allServices = ref.watch(allServicesProvider);
    final  selectedServices = ref.watch(selectedServicesProvider.notifier);

    return allServices.when(
      data: (services) {
        return Wrap(
          children: services.map((service) {
            final isSelected = selectedServices.state.contains(service);
            return ChoiceChip(
              label: Text(service.name),
              selected: isSelected,
              onSelected: (isSelected) {
                final selectedServicesNotifier = ref.watch(selectedServicesProvider.notifier);
                if (isSelected) {
                  selectedServicesNotifier.add(service);
                } else {
                  selectedServicesNotifier.remove(service);
                }
              },
            );
          }).toList(),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  },
),


  

              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSliderChanged(double value) {
  }
}
