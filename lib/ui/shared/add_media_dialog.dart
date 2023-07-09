import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/barrel_models.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/ui/shared/barrel_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils.dart';

class AddMediaDialog extends ConsumerWidget {
  AddMediaDialog({super.key});
  late Vehicle vehicle;
  var appUser;
  late AddedMedia state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    vehicle = ref.read(currentVehicleProvider);
    appUser = ref.read(appUserProvider);
    state = ref.watch(addedMediaProvider);

    final notifier = ref.read(addedMediaProvider.notifier);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const AddedMediaContiner(),
            ButtonsBar(),
            state.addedMedia.isNotEmpty
                ? buildDoneButton(context, ref)
                : Container(),
          ],
        ),
      ),
    );
  }

  buildDoneButton(context, ref) => Row(
        children: [
          Expanded(
              child: ElevatedButton.icon(
                  onPressed: () {
                    if (state.addedMedia.isEmpty) {
                      return;
                    }
                    var imageList = state.addedMedia.map((e) => e.url).toList();
                    updateVehicleDoc(imagesList: imageList);
                    // ref.refresh(currentVehicleProvider);
                    ref.read(addedMediaProvider.notifier).clearMedia();
                    CurrentVehicleNotifier notifier =
                        ref.read(currentVehicleProvider.notifier);
                    notifier.addVehicleImages(imageList);
                    Navigator.pop(context);
                    // ref.refresh(currentVehicleProvider);
                  },
                  icon: const Icon(
                    Icons.check,
                    size: 40,
                  ),
                  label: const Text('Done')))
        ],
      );

  updateVehicleDoc({required List<String?> imagesList}) async {
    vehicle.images?.insertAll(0, imagesList);

    final DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(appUser?.uuid)
        .collection('vehicles')
        .doc(vehicle.id);
    await docRef.update(vehicle.toMap());
  }
}

class AddedMediaContiner extends ConsumerWidget {
  const AddedMediaContiner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addedMediaProvider);

    return Flexible(
      // flex: 1,
      fit: FlexFit.loose,
      child: Container(
        child: state.addedMedia.isNotEmpty
            ? ListView(
                shrinkWrap: true,
                // alignment: WrapAlignment.start,
                // crossAxisAlignment: WrapCrossAlignment.center,
                // spacing: 20,
                children: state.addedMedia
                    .map(
                      (e) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MediaUploadItemWidget(
                            appMedia: e,
                            // onRemove:(e) {
                            //   state.addedMedia.remove(e);},
                          ),
                          const Divider(),
                        ],
                      ),
                    )
                    .toList(),
              )
            : Container(
                height: 0,
              ),
      ),
    );
  }
}

class ButtonsBar extends ConsumerWidget {
  ButtonsBar({Key? key}) : super(key: key);
  var appUser, vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    appUser = ref.read(appUserProvider);
    vehicle = ref.read(currentVehicleProvider);
    final mediaNotifier = ref.read(addedMediaProvider.notifier);

    return Row(
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
                var croppedImage = await Utils().crop16_x_9(pickedMedia![0]);
                var croppedImageFile =
                    await Utils().createFileFromCroppedFile(croppedImage!);

                mediaNotifier.addMedia(Media(mediaFile: croppedImageFile));
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
                    images.map((e) => Media(mediaFile: e)).toList();
                mediaNotifier.setAddedMedia(selectedmedia);
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
    );
    //     ],
    //   ),
    // );
  }
}
