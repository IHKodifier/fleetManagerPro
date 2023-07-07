import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allServicesProvider = StreamProvider<List<Service>>((ref) async* {
  final user = ref.read(appUserProvider); // replace this with your own user id
 final servicesCollection = FirebaseFirestore.instance.collection('users').doc(user!.uuid).collection('services');
  yield* servicesCollection.snapshots().map((snapshot) => snapshot.docs.map((doc) => Service.fromMap(doc.data())).toList());
});






final selectedServicesProvider =
    StateNotifierProvider<SelectedServicesNotifier, List<Service>>((ref) => SelectedServicesNotifier());

class SelectedServicesNotifier extends StateNotifier<List<Service>> {
  SelectedServicesNotifier() : super([]);

  void add(Service service) {
    state = [...state, service];
  }

  void remove(Service service) {
    state = state.where((s) => s != service).toList();
  }
}
final locationStreamProvider = StreamProvider<List<String>>((ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(ref.read(appUserProvider)?.uuid)
      .collection('locations')
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs.map((doc) => doc.data()['name'] as String).toList();
  });
});
