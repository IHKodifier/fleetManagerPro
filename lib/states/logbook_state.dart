import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/destination.dart';
import 'package:fleet_manager_pro/states/logbook.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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


final logbookStreamProvider = StreamProvider.autoDispose.family<List<Logbook>,String>((ref,vehicleId)  {
 final user = ref.read(appUserProvider);
 final logbookStream = FirebaseFirestore.instance
 .collection('users')
 .doc(user!.uuid)
 .collection('vehicles')
 .doc(vehicleId)
 .collection('logbook')
 .orderBy('timestamp',descending: true)
 .snapshots();
   return logbookStream.map((querySnapshot) => 
   querySnapshot.docs.map((doc) => Logbook.fromMap(doc.data())).toList());
});








