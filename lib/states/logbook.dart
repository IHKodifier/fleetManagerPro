import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Logbook extends Equatable {
  final String id;
  final Timestamp timestamp;
  final List<String> placesVisited;
  final double kmsTravelled;
  final int startReading;
  final int endReading;
  final String driver;

  Logbook._({
    required this.id,
    required this.timestamp,
    required this.placesVisited,
    required this.kmsTravelled,
    required this.startReading,
    required this.endReading,
    required this.driver,
  });

  factory Logbook({
    required String id,
    Timestamp? timestamp,
    List<String>? placesVisited,
    required double kmsTravelled,
    required int startReading,
    required int endReading,
    required String driver,
  }) {
    return Logbook._(
      id: id,
      timestamp: timestamp ?? Timestamp.now(),
      placesVisited: placesVisited ?? [],
      kmsTravelled: kmsTravelled,
      startReading: startReading,
      endReading: endReading,
      driver: driver,
    );
  }

  @override
  List<Object> get props => [
        id,
        timestamp,
        placesVisited,
        kmsTravelled,
        startReading,
        endReading,
        driver
      ];

  @override
  bool get stringify => true;

  Logbook copyWith({
    String? id,
    Timestamp? timestamp,
    List<String>? placesVisited,
    double? kmsTravelled,
    int? startReading,
    int? endReading,
    String? driver,
  }) {
    return Logbook._(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      placesVisited: placesVisited ?? this.placesVisited,
      kmsTravelled: kmsTravelled ?? this.kmsTravelled,
      startReading: startReading ?? this.startReading,
      endReading: endReading ?? this.endReading,
      driver: driver ?? this.driver,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'placesVisited': placesVisited,
      'kmsTravelled': kmsTravelled,
      'startReading': startReading,
      'endReading': endReading,
      'driver': driver,
    };
  }

  factory Logbook.fromMap(Map<String, dynamic> map) {
    return Logbook(
      id: map['id'],
      timestamp: map['timestamp'],
      placesVisited: List<String>.from(map['placesVisited']),
      kmsTravelled: map['kmsTravelled'],
      startReading: map['startReading'],
      endReading: map['endReading'],
      driver: map['driver'],
    );
  }

}
