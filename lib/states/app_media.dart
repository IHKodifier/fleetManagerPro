import 'dart:io';

import 'package:equatable/equatable.dart';

class Media extends Equatable {
  final File mediaFile;
  final String? url;

  const Media({
    required this.mediaFile,
    this.url,
  });

  @override
  List<Object?> get props => [mediaFile, url];

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
