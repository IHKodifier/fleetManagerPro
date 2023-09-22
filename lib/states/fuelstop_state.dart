import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/fuelstop.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final fuelstopStreamProvider = StreamProvider.autoDispose
    .family<List<FuelStop>, String>((ref, vehicleId) {
  final user = ref.watch(appUserProvider);
  final vehicleStream = FirebaseFirestore.instance
      .collection('users')
      .doc(user?.uuid)
      .collection('vehicles')
      .doc(vehicleId)
      .collection('fuelstops')
      .orderBy('driven', descending: true)
      .snapshots();
  return vehicleStream.map((querySnapshot) => querySnapshot.docs
      .map((doc) => FuelStop.fromMap(doc.data()))
      .toList());
});
