import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fleet_manager_pro/states/service.dart';

class Maintenance extends Equatable {
  final String id;
  String? location;
  Timestamp? timestamp;
  int? cost;
  List<Service?>? services;

  Maintenance(
    this.id,
    this.location,
    this.timestamp,
    this.cost,
  );

  Maintenance copyWith({
    String? id,
    String? location,
    Timestamp? timestamp,
    int? cost,
  }) {
    return Maintenance(
      id ?? this.id,
      location ?? this.location,
      timestamp ?? this.timestamp,
      cost ?? this.cost,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    if (location != null) {
      result.addAll({'location': location});
    }
    if (timestamp != null) {
      result.addAll({
        'timestamp': {
          'seconds': timestamp!.seconds,
          'nanoseconds': timestamp!.nanoseconds,
        }
      });
    }
    if (cost != null) {
      result.addAll({'cost': cost});
    }

    return result;
  }

  factory Maintenance.fromMap(Map<String, dynamic> map) {
    return Maintenance(
      map['id'] ?? '',
      map['location'],
      map['timestamp'] != null ? Timestamp.fromDate(map['timestamp']) : null,
      map['cost']?.toInt(),
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
  List<Object> get props => [id, location!, timestamp!, cost!];
}
