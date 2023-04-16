import 'dart:io';
import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;



enum UploadStatus {
  notStarted,
  inProgress,
  completed,
  error,
}

final mediaUploaderProvider =
    StateNotifierProvider.autoDispose<MediaUploaderNotifier, UploadStatus>(
  (ref) => MediaUploaderNotifier(),
);

class MediaUploaderNotifier extends StateNotifier<UploadStatus> {
  MediaUploaderNotifier() : super(UploadStatus.notStarted);

  Future<String> startUpload({
    required File file,
    required AppUser? appUser,
    required Vehicle? vehicle,
  }) async {
    try {
     final fileName = path.basename(file.path);

      

      final storageRef = FirebaseStorage.instance.ref(
        'userdata/${appUser?.uuid}/uploads/$fileName',
      );
      final uploadTask = storageRef.putFile(file);
      state = UploadStatus.inProgress;
      final snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        final downloadUrl = await storageRef.getDownloadURL();
        // TODO: Save downloadUrl to database or somewhere else
        state = UploadStatus.completed;
        return downloadUrl;
      }
    } on FirebaseException catch (e) {
      state = UploadStatus.error;
      throw Exception(e.message);
    }
    state = UploadStatus.notStarted;
    throw Exception('Failed to upload file');
  }
}
