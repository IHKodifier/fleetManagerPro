import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FuelStop extends Equatable {
  final String id;
  final int driven;
  final double litres;
  double pricePerLitre;
  final double totalCost;
  final Timestamp timestamp;

  FuelStop._({
    required this.id,
    required this.driven,
    required this.litres,
    required this.pricePerLitre,
    required this.totalCost,
    required this.timestamp,
  });

  factory FuelStop({
    required String id,
    required int driven,
    required double litres,
    double? pricePerLitre,
    required double totalCost,
    Timestamp? timestamp,
  }) {
    return FuelStop._(
      id: id,
      driven: driven,
      litres: litres,
      pricePerLitre: pricePerLitre ?? totalCost / litres,
      totalCost: totalCost,
      timestamp: timestamp ?? Timestamp.now(),
    );
  }

  @override
  List<Object> get props =>
      [id, driven, litres, pricePerLitre, totalCost, timestamp];

  @override
  bool get stringify => true;

  FuelStop copyWith({
    String? id,
    int? driven,
    double? litres,
    double? pricePerLitre,
    double? totalCost,
    Timestamp? timestamp,
  }) {
    return FuelStop._(
      id: id ?? this.id,
      driven: driven ?? this.driven,
      litres: litres ?? this.litres,
      pricePerLitre: pricePerLitre ?? this.pricePerLitre,
      totalCost: totalCost ?? this.totalCost,
      timestamp: timestamp ?? this.timestamp,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'driven': driven,
      'litres': litres,
      'pricePerLitre': pricePerLitre,
      'totalCost': totalCost,
      'timestamp': timestamp,
    };
  }

  factory FuelStop.fromMap(Map<String, dynamic> map) {
    return FuelStop(
      id: map['id'],
      driven: map['driven'],
      litres: map['litres'],
      pricePerLitre: map['pricePerLitre'],
      totalCost: map['totalCost'],
      timestamp: map['timestamp'],
    );
  }
}
