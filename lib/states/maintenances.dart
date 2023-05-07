import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:fleet_manager_pro/states/service.dart';
enum MaintenanceType {
  Regular_Scheduled,
Regular_Unscheduled,
One_Off,
tuneUp_ECM,
BodyWorks,
Polish_Detailing,
Repairs,
Other
}

class Maintenance extends Equatable {
  String? id;
  String? location;
  Timestamp? timestamp;
  MaintenanceType type;
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
    this.type=MaintenanceType.Regular_Scheduled,
  });

  Maintenance copyWith({
    String? id,
    String? location,
    Timestamp? timestamp,
    int?  kmsDriven,
    int? cost,
    MaintenanceType? type ,
    int? ki
  }) {
    return Maintenance(
      id: id ?? this.id,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
      cost: cost ?? this.cost,
      type: type?? this.type
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
      id: map['id'] ?? '',
      location: map['location'],
     timestamp:  map['timestamp'] != null ? Timestamp.fromDate(map['timestamp']) : null,
     cost:  map['cost']?.toInt(),
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
