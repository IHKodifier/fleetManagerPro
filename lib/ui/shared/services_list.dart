import 'package:fleet_manager_pro/states/service_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../states/service.dart';



class ServiceListWidget extends ConsumerWidget {
  final Function(List<Service>) onSelectionChanged;
   late Set<Service> selectedServices;
  late WidgetRef ref;

   ServiceListWidget({Key? key, required this.onSelectionChanged}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef  ref) {
    this.ref= ref;
    final services = ref.watch(allServicesProvider);
    final selectedServices = ref.watch(selectedServicesProvider);

    return Wrap(
      spacing: 8,
      children: services.when(data: onData, error: onError, loading: onLoading));
    
  }

  List<Widget> onData(List<Service> data) {
    return data.
map((service) {
       return ChoiceChip(
  label: ListTile(
    title: Text(service.name),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Perform edit action here
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // Perform delete action here
          },
        ),
      ],
    ),
  ),
  selected: selectedServices.contains(service),
  onSelected: (isSelected) {
    // Handle selection here
  },
);

      }).toList();
  }

  List<Widget> onError(Object error, StackTrace stackTrace)=>[
    const Text('error encountered'),
    Text(error.toString()),
    
    ];

  List<Widget> onLoading() =>[const CircularProgressIndicator()];
}



