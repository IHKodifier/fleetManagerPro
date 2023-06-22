import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final maintenanceStreamProvider =
    StreamProvider.autoDispose.family<List<Maintenance>, String>((ref, vehicleId) {
  final user = ref.watch(appUserProvider);
  final vehicleStream = FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uuid)
      .collection('vehicles')
      .doc(vehicleId)
      .collection('maintenances').orderBy('kmsDriven',descending: true)
      .snapshots();
  return vehicleStream.map((querySnapshot) => querySnapshot.docs
      .map((doc) => Maintenance.fromMap(doc.data()))
      .toList());
});
