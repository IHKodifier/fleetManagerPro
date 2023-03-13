
import 'dart:convert';
import 'dart:core';

import 'package:equatable/equatable.dart';

import 'package:fleet_manager_pro/states/vehicle.dart';

class AppUser extends Equatable {


  final String userId;
  String? location;
  String? profileType;
  String? email;
    String? phone;
  AppUser({
    required this.userId,
    this.location,
    this.profileType,
    this.email,
    this.phone,
  });


      @override
      // TODO: implement props
  List<Object> get props {
    return [
      userId,
      location!,
      profileType!,
      email!,
      phone!,
    ];
  }

  AppUser copyWith({
    String? userId,
    String? location,
    String? profileType,
    String? email,
    String? phone,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      location: location ?? this.location,
      profileType: profileType ?? this.profileType,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'userId': userId});
    if(location != null){
      result.addAll({'location': location});
    }
    if(profileType != null){
      result.addAll({'profileType': profileType});
    }
    if(email != null){
      result.addAll({'email': email});
    }
    if(phone != null){
      result.addAll({'phone': phone});
    }
  
    return result;
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      userId: map['userId'] ?? '',
      location: map['location'],
      profileType: map['profileType'],
      email: map['email'],
      phone: map['phone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) => AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(userId: $userId, location: $location, profileType: $profileType, email: $email, phone: $phone)';
  }
}