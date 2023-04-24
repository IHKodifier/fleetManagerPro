/// [MediaUploadItemWidget] displays a single item in the upload queue

import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/ui/shared/media_thumbnail.dart';
import 'package:fleet_manager_pro/ui/shared/uploadprogress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MediaUploadItemWidget extends ConsumerWidget {
  const MediaUploadItemWidget({
    Key? key,
    required this.appMedia,
  }) : super(key: key);

  final Media appMedia;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(appUserProvider);
    // final uploadUtility = MediaUploadProgressProvider(
    //     appMedia: appMedia, userId: appUser?.uuid ?? '');

    return Row(
      children: [
        MediaThumbnail(appMedia: appMedia),
        const SizedBox(width: 16),
        Expanded(
          child: MediaUploadProgressWidget(
            appMedia: appMedia,
          ),
        ),
      ],
    );
  }
}
