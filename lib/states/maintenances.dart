import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:fleet_manager_pro/states/service.dart';


class Maintenance extends Equatable {
  String? id;
  String? location;
  DateTime? timestamp;
double? litres;
  int kmsDriven;
  int? cost;
  List<Service?>? services;

  Maintenance({
    this.id,
    this.location,
    this.timestamp,
    this.kmsDriven = 0,
    this.cost,
    this.services,
    this.litres,
  });

  Maintenance copyWith({
    String? id,
    String? location,
    DateTime? timestamp,
    int?  kmsDriven,
    int? cost,
    double? litres,
  }) {
    return Maintenance(
      id: id ?? this.id,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp!,
      cost: cost ?? this.cost,
      litres: litres?? this.litres
    );
  }

Map<String, dynamic> toMap() {
  return {
    'id': id,
    'location': location,
    'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : null,
    'litres': litres != null ? litres : null,
    // 'type': type.index,
    'kmsDriven': kmsDriven,
    'cost': cost,
    'services': services?.map((e) => e?.toMap()).toList(),
  };
}


factory Maintenance.fromMap(Map<String, dynamic> map) {
  DateTime? parsedTimestamp;
  if (map['timestamp'] is Timestamp) {
    parsedTimestamp = (map['timestamp'] as Timestamp).toDate();
  }

  return Maintenance(
    id: map['id'] as String?,
    location: map['location'] as String?,
    timestamp: parsedTimestamp,
    // type: MaintenanceType.values[map['type'] as int],
    kmsDriven: map['kmsDriven'] as int,
    litres: map['litres']?.toDouble(),
    cost: map['cost'].toInt(),
    services: (map['services'] as List<dynamic>?)
        ?.map((e) => e != null ? Service.fromMap(e as Map<String, dynamic>) : null)
        .toList(),
  );
}



  String toJson() => json.encode(toMap());

  factory Maintenance.fromJson(String source) =>
      Maintenance.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Maintenance(id: $id, location: $location, timestamp: $timestamp, cost: $cost)';
  }

  @override
  List<Object> get props => [id!, location!, timestamp!, cost!];
}
