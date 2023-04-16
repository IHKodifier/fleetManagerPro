
import 'dart:io';

import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MediaUploader extends ConsumerWidget {
  final File file;
  final AppUser? appUser;
  final Vehicle? vehicle;

  MediaUploader({
    required this.file,
    required this.appUser,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(mediaUploaderProvider.notifier);
    final status = ref.watch(mediaUploaderProvider);

    switch (status) {
      case UploadStatus.notStarted:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.cloud_upload),
              onPressed: () {
                notifier.startUpload(
                  file: file,
                  appUser: appUser,
                  vehicle: vehicle,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                // TODO: Delete the file
              },
            ),
          ],
        );
      case UploadStatus.inProgress:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.pause),
              onPressed: () {
                // TODO: Pause the upload
              },
            ),
            SizedBox(
              width: 80,
              child: LinearProgressIndicator(
                value: 0.65, // TODO: Set the progress value
              ),
            ),
          ],
        );
      case UploadStatus.completed:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.check_circle),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                // TODO: Delete the file
              },
            ),
          ],
        );
      case UploadStatus.error:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.error),
              onPressed: () {
                notifier.startUpload(
                  file: file,
                  appUser: appUser,
                  vehicle: vehicle,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_forever,),
              onPressed:(){},),],
              );
    }}}