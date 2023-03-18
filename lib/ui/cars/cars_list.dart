import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/app_user_state.dart';

final vehiclesProvider = StreamProvider.autoDispose<List<Vehicle>>((ref) {
  final firestore = FirebaseFirestore.instance;
  final collectionReference = firestore
      .collection('users')
      .doc(ref.read(appUserProvider)!.uuid)
      .collection('vehicles');
  return collectionReference.snapshots().map((querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Vehicle.fromMap(data);
    }).toList();
  });
});

/// this is just a rubbish class
class Fruit {
  Fruit(
    this.name,
    this.quantity,
  );

  factory Fruit.fromJson(String source) => Fruit.fromMap(json.decode(source));

  factory Fruit.fromMap(Map<String, dynamic> map) {
    return Fruit(
      map['name'] ?? '',
      map['quantity']?.toInt() ?? 0,
    );
  }

  final String name;
  final int quantity;

  @override
  String toString() => 'Fruit(name: $name, quantity: $quantity)';

  Fruit copyWith({
    String? name,
    int? quantity,
  }) {
    return Fruit(
      name ?? this.name,
      quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'quantity': quantity});

    return result;
  }

  String toJson() => json.encode(toMap());
}

class CarsList extends ConsumerWidget {
  const CarsList({super.key});

  ///this one is effective keep this delete others
  Widget onData(List<Vehicle> data) {
    return ListView(
      children: data
          .map((e) => ListTile(
                title: Text(e.make!),
                trailing: Text(e.model!),
              ))
          .toList(),
    );
  }

  Widget onError(Object error, StackTrace stackTrace) {
    return Text(error.toString() + stackTrace.toString());
  }

  Widget onLoading() {
    return const CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehiclesProvider);

    return vehicles.when(data: onData, error: onError, loading: onLoading);
  }
}

class CarsListPage extends ConsumerWidget {
   CarsListPage({super.key});
  late BuildContext buildContext;

  Widget onError(Object error, StackTrace stackTrace) {
    
    return Text(error.toString() + stackTrace.toString());
  }

  Widget onLoading() {
    return const CircularProgressIndicator(
      strokeWidth: 10,
    );
  }

  Widget onData(List<Fruit> data) {
    return ListView(
      children: data
          .map((e) => ListTile(
                title: Text(e.name),
                trailing: Text(e.quantity.toString()),
              ))
          .toList(),
    );
  }

  void onFABPressed() {
   
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    buildContext=context;
    final stream = ref.watch(vehiclesProvider);

    return Scaffold(
      appBar: AppBar(),
      body: const CarsList(),
      floatingActionButton: FloatingActionButton(
          onPressed: onFABPressed,
          child: const Icon(
            Icons.add,
            size: 40,
          )),
    );
  }
}
