import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/barrel_states.dart';

/// [MediaUploadProgressState] represents the state of an upload
class MediaUploadProgressState extends Equatable {
  MediaUploadProgressState({
    required this.progress,
    this.isNotStarted = true,
    this.isInProgress = false,
    this.isComplete = false,
    this.isError = false,
    this.errorMessage = '',
  });
  final double progress;
  late bool isNotStarted;
  late bool isInProgress;
  late bool isComplete;
  late bool isError;
  late String? errorMessage;

  @override
  // TODO: implement props
  List<Object?> get props => [progress, isError, isComplete, isNotStarted];

  MediaUploadProgressState copyWith(
      {double? progress,
      bool? isNotStarted,
      bool? isInProgress,
      bool? isComplete,
      bool? isError,
      String? errorMessage}) {
    return MediaUploadProgressState(
      progress: progress ?? this.progress,
    );
  }
}

final mediaUploadProgressProviderFamily = StateNotifierProvider.family.autoDispose<
    MediaUploadProgressNotifier, MediaUploadProgressState, Media>((ref, media) {
  final userId = ref.read(appUserProvider)!.uuid;
  return MediaUploadProgressNotifier(
      MediaUploadProgressState(
        progress: 0.0,
      ),
      ref,
      media: media,
      userId: userId);
});

class MediaUploadProgressNotifier
    extends StateNotifier<MediaUploadProgressState> {
  MediaUploadProgressNotifier(super.state, this.ref,
      {required this.media, required this.userId});
final StateNotifierProviderRef ref;
  final Media media;
  final String userId;
  final _uploadProgressStreamController = StreamController<double>();
  late UploadTask? _uploadTask;
  Stream<double> get uploadProgressStream =>
      _uploadProgressStreamController.stream;

  Future<String?> startUpload() async {
    _setStarted();
    final file = File(media.mediaFile.path);
    final fileName = file.path.split('/').last;

    final storageRef = FirebaseStorage.instance.ref(
      'userdata/$userId/uploads/$fileName',
    );

    _uploadTask = storageRef.putFile(file);
    _uploadTask!.snapshotEvents.listen((taskSnapshot) {
      final progress =
          taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
      _uploadProgressStreamController.sink.add(progress);
    });

    await _uploadTask!.whenComplete(() async {
      state.isComplete=true;
      state.isInProgress= false;
      // _uploadTask.
      _uploadProgressStreamController.close();
      media.url = await storageRef.getDownloadURL();
      // ref.read(addedMediaProvider.notifier).updateMediaUrl(media);
      _setCompleted();
      
    });
    return null;
  }

  void _setStarted() {
    state.isNotStarted = false;
    state.isInProgress = true;
    state = state.copyWith();
  }

  void _setCompleted() {
    state.isNotStarted = false;
    state.isInProgress = false;
    state.isComplete = true;
    state = state.copyWith();
  }

  void _setError(String errorMessage) {
    state.isNotStarted = false;
    state.isInProgress = false;
    state.isComplete = false;
    state.isError = true;
    state.errorMessage = errorMessage;
    state = state.copyWith();
  }
}
