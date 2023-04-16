import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AppMedia {
  AppMedia(
    this.mediaFile, {
    this.downloadUrl,
  });

  String? downloadUrl;
  late File mediaFile;

  AppMedia fromXfile(XFile xFile) => AppMedia(xFile as File);

  AppMedia copyWith({
    File? file,
    String? downloadUrl,
  }) {
    return AppMedia(
      file ?? mediaFile,
      // downloadUrl ?? this.downloadUrl,
    );
  }

  void setUrl(String url)=>downloadUrl=url;
}