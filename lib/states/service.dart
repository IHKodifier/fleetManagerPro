

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final String name;
  //  Timestamp? timestamp;
  int cost;

  Service(
    {required this.name,
    // this.timestamp,
    this.cost=0,}
  );

  Service copyWith({
    String? name,
    Timestamp? timestamp,
    int? cost,
  }) {
    return Service(
      name:name ?? this.name,
      // timestamp ?? this.timestamp,
      cost: cost ?? this.cost,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'cost': cost});

    return result;
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      name:map['name'] ?? '',
      // map['timestamp'] ?? 0,
      cost:map['cost']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Service.fromJson(String source) =>
      Service.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Service(name: $name,  cost: $cost)';
  }

  @override
  List<Object> get props => [
        name,
        // timestamp!,
        cost
      ];  
}
