import 'package:fleet_manager_pro/states/add_media_state.dart';
import 'package:fleet_manager_pro/states/vehicle.dart';
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

  // void _kMedia({required ImageSource imageSource}) async {
  //   final pickedFile = await ImagePicker().pickImage(source: imageSource);
  //   if (pickedFile != null) {
  //     final file = File(pickedFile.path);
  //     // _uploadImage(file);
  //   }
  // }

  // void _pickMultiMedia({required ImageSource imageSource}) async {
  //   final pickedFile = await ImagePicker().pickImage(source: imageSource);
  //   if (pickedFile != null) {
  //     final file = File(pickedFile.path);
  //     // _uploadImage(file);
  //   }
  // }

  // void _uploadImage(File file) async {
  // final appuser = ref.read(appUserProvider);
  // final vehicle = ref.read(currentVehicleProvider);
  // final fileName = Path.basename(file.path);
  // final Reference firebaseStorageRef = FirebaseStorage.instance
  //     .ref()
  //     .child('userdata/${appuser?.uuid}/images/$fileName');
  // final UploadTask uploadTask = firebaseStorageRef.putFile(file);
  // await uploadTask.whenComplete(() async {
  //   final String downloadURL = await firebaseStorageRef.getDownloadURL();
  //   print('File uploaded to Firebase at $downloadURL');
  //   final DocumentReference docRef = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(appuser?.uuid)
  //       .collection('vehicles')
  //       .doc(vehicle.id);
  //   // final List<String> imagesList = List<String>.from(state.images ?? []);
  //   imagesList.add(downloadURL);
  //   await docRef.update({'images': imagesList});
  //   ref.refresh(currentVehicleProvider);
  //   Navigator.pop(context);
  // });
  // }

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
                // color: Colors.blue,
                // height: 500,
                child: state.media.isNotEmpty
                    ? Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 20,
                        children: state.media
                            .map(
                              (e) => SizedBox(
                                // aspectRatio: 16/9.0,
                                height: 100,
                                width: 120,
                                child: Image.file(
                                  e.file,
                                  // height: 100,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : Container(
                        height: 0,
                      ),
              )),
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
                      for (var file in pickedMedia) {
                        mediaNotifier.addMedia(Media(file));
                      }
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
                          images.map((e) => Media(e)).toList();
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
