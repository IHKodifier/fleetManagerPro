import 'dart:io';

import 'package:equatable/equatable.dart';

class Media extends Equatable {
  final File mediaFile;
  late  String? url;

   Media({
    required this.mediaFile,
    this.url,
  });

  @override
  List<Object?> get props => [mediaFile];

  Media copyWith({
    File? mediaFile,
    String? url,
  }) {
    return Media(
      mediaFile: mediaFile ?? this.mediaFile,
      url: url ?? this.url,
    );
  }
}
