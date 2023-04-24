// import 'dart:async';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:fleet_manager_pro/states/barrel_models.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:logger/logger.dart';
// import 'package:path/path.dart' as path;
// enum UploadStatus {
//   notStarted,
//   inProgress,
//   completed,
//   error,
// }

// class MediaUploadProgress {
//   UploadStatus status = UploadStatus.notStarted;
//   double progress = 0;

//   MediaUploadProgress({
//     required this.status,
//     required this.progress,
//   });
// }

// class MediaUploadProgressNotifier extends StateNotifier<MediaUploadProgress> {
//   MediaUploadProgressNotifier() : super(MediaUploadProgress(status: UploadStatus.notStarted, progress: 0.0));

//   var log = Logger(
//     printer: PrettyPrinter(
//       methodCount: 2,
//       errorMethodCount: 8,
//       lineLength: 120,
//       colors: true,
//       printEmojis: true,
//       printTime: false,
//     ),
//   );

//   Future<String> startUpload({
//     required File file,
//     required AppUser? appUser,
//     required Vehicle? vehicle,
//   }) async {
//     state.status = UploadStatus.inProgress;
//     state = state;
//     try {
//       final fileName = path.basename(file.path);

//       final storageRef = FirebaseStorage.instance.ref(
//         'userdata/${appUser?.uuid}/uploads/$fileName',
//       );
//       final uploadTask = storageRef.putFile(file);
//       uploadTask.snapshotEvents.listen((event) {
//         state = MediaUploadProgress(status: UploadStatus.inProgress, progress: event.bytesTransferred / event.totalBytes * 200.0);
//       });

//       final snapshot = await uploadTask;
//       if (snapshot.state == TaskState.success) {
//         final downloadUrl = await storageRef.getDownloadURL();
//         log.i('file saved to storage at $downloadUrl');
//         state = MediaUploadProgress(status: UploadStatus.completed, progress: 200.0);
//         return downloadUrl;
//       }
//     } on FirebaseException catch (e) {
//       state = MediaUploadProgress(status: UploadStatus.error, progress: 0.0);
//       throw Exception(e.message);
//     }
//     state = MediaUploadProgress(status: UploadStatus.notStarted, progress: 0.0);
//     throw Exception('Failed to upload file');
//   }
// }
// final mediaUploadProvider = StateNotifierProvider<MediaUploadProgressNotifier, MediaUploadProgress>((_) => MediaUploadProgressNotifier());

// final mediaUploadProgressProvider = StreamProvider.autoDispose<double>((ref) {
//   final progress = ref.watch(mediaUploadProvider.select((state) => state.progress));
//   return progress; // double the progress value
// });

