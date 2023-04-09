import 'package:fleet_manager_pro/states/add_media_state.dart';
import 'package:fleet_manager_pro/states/vehicle.dart';
import 'package:fleet_manager_pro/ui/shared/media_uploader.dart';
import 'package:fleet_manager_pro/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddMediaDialog extends ConsumerStatefulWidget {
  const AddMediaDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddMediaDialogState();
}

class _AddMediaDialogState extends ConsumerState<AddMediaDialog> {
  late final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addMediaStateProvider);
    final mediaNotifier = ref.watch(addMediaStateProvider.notifier);

    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            // flex: 1,
            fit: FlexFit.loose,
            child: Container(
              child: state.media.isNotEmpty
                  ? ListView(
                    shrinkWrap: true,
                      // alignment: WrapAlignment.start,
                      // crossAxisAlignment: WrapCrossAlignment.center,
                      // spacing: 20,
                      children: state.media
                          .map(
                            (e) => Column(
                              children: [
                                MediaUploader(e),
                                Divider(),
                              ],
                            ),
                          )
                          .toList(),
                    )
                  : Container(
                      height: 0,
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      final pickedMedia = await Utils.pickMediafromCamera();
                      //pickedMedia.length will always be 1 . time to crop it
                      var croppedImage =
                          await Utils().crop16_x_9(pickedMedia![0]);
                      var croppedImageFile = await Utils()
                          .createFileFromCroppedFile(croppedImage!);

                      mediaNotifier.addMedia(AppMedia(croppedImageFile));
                      // for (var file in pickedMedia) {
                      //   mediaNotifier.addMedia(Media(file));
                      // }
                    },
                    icon: const Icon(
                      Icons.camera,
                      size: 45,
                    ),
                  ),
                  const Text('Take Photo'),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      final images = await Utils.pickMediafromGallery();
                      final selectedmedia =
                          images.map((e) => AppMedia(e)).toList();
                      mediaNotifier.setMedia(selectedmedia);
                    },
                    icon: const Icon(
                      Icons.photo_album,
                      size: 45,
                    ),
                  ),
                  const Text('Choose from Gallery'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
