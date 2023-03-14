import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fruitsProvider = StreamProvider.autoDispose<List<Fruit>>((ref) {
  final firestore = FirebaseFirestore.instance;
  final collectionReference = firestore.collection('fruits');

  return collectionReference.snapshots().map((querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Fruit.fromMap(data);
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

  Widget onError(Object error, StackTrace stackTrace) {
    return Text(error.toString() + stackTrace.toString());
  }

  Widget onLoading() {
    return const CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fruits = ref.watch(fruitsProvider);

    return fruits.when(data: onData, error: onError, loading: onLoading);
  }
}

class CarsListPage extends ConsumerWidget {
  const CarsListPage({super.key});

  Widget onError(Object error, StackTrace stackTrace) {
    return Text(error.toString() + stackTrace.toString());
  }

  Widget onLoading() {
    return const CircularProgressIndicator(strokeWidth: 10,);
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(fruitsProvider);

    return Scaffold(
      appBar: AppBar(),
      body:  CarsList(),
    );
  }
}
