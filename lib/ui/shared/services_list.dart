import 'package:fleet_manager_pro/states/service_selection_state.dart';
import 'package:fleet_manager_pro/ui/shared/service_chip.dart';
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
    final services = ref.watch(servicesProvider);
    final selectedServices = ref.watch(selectedServicesProvider);

    return Wrap(
      spacing: 8,
      children: services.when(data: onData, error: onError, loading: onLoading));
    
  }

  List<Widget> onData(List<Service> data) {
    return data.
map((service) {
        return ChoiceChip(
          label: Text(service.name),
          selected: selectedServices.contains(service),
          onSelected: (isSelected) {
            // final servicesProviderNotifier = ref.read(servicesProvider.notifier);
            // servicesProviderNotifier.toggleServiceSelection(service);

            // final newSelectedServices = servicesProviderNotifier.selectedServices;
            // onSelectionChanged(newSelectedServices);
          },
        );
      }).toList();
  }

  List<Widget> onError(Object error, StackTrace stackTrace)=>[
    Text('error encountered'),
    Text(error.toString()),
    
    ];

  List<Widget> onLoading() =>[CircularProgressIndicator()];
}



