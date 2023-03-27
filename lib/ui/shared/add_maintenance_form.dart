import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddMaintenanceForm extends ConsumerStatefulWidget {
  const AddMaintenanceForm({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddMintenanceFormState();
}

class _AddMintenanceFormState extends ConsumerState<AddMaintenanceForm> {

  @override
  Widget build(BuildContext context) {
     return   Card(child: Column(
      mainAxisSize: MainAxisSize.min,
       children:const  [
         Text('Add Maintenance'),
         Text('Add Maintenance'),
         Text('Add Maintenance'),
         Text('Add Maintenance'),
         Text('Add Maintenance'),
       ],
     ),);
  }
}