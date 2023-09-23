import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/destination.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';

final allDestinationsProvider =
    StreamProvider.autoDispose<List<Destination>>((ref) {
  final appUser = ref.watch(appUserProvider);
  return FirebaseFirestore.instance
      .collection('users')
      .doc(appUser!.uuid)
      .collection('destinations')
      .snapshots()
      .map((event) =>
          event.docs.map((e) => Destination.fromMap(e.data())).toList());
});
