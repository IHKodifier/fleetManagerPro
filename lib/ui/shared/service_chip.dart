// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fleet_manager_pro/states/barrel_models.dart';
// import 'package:fleet_manager_pro/states/barrel_states.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../states/service_selection_state.dart';


// final servicesProvider = StreamProvider.autoDispose<List<Service>>((ref) {
//   final currentUser = ref.watch(appUserProvider);
//   final userDocRef = FirebaseFirestore.instance.collection('users').doc(currentUser?.uuid).collection('services');
//   return userDocRef.snapshots().map((snapshot) {
//     return snapshot.docs.map((doc) => Service.fromMap(doc.data())).toList();
//   });
// });
// class ServicesChips extends ConsumerWidget {
//   // final Function(Set<Service>) onSelectionChanged;

//   const ServicesChips({
//     Key? key,
//     // required this.onSelectionChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final AsyncValue<List<Service>> services = ref.watch(servicesProvider);
// final Set<Service> selectedServices = ref.watch(selectedServicesProvider);
//     return services.when(
//       data: (List<Service> data) {
        

//         return Wrap(
//           spacing: 8,
//           children: data.map((service) {
//             return ChoiceChip(
//               label: Text(service.name),
//               selected: selectedServices.contains(service),
//               selectedColor: Theme.of(context).colorScheme.primary,
//               onSelected: (isSelected) {
//                 ref.read(selectedServicesProvider.notifier).toggleSelection(service);

//               },
//             );
//           }).toList(),
//         );
//       },
//       loading: () => Center(child: const CircularProgressIndicator()),
//       error: (error, stackTrace) => Text('Error: $error'),
//     );
//   }
// }