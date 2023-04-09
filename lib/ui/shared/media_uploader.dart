import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../../states/add_media_state.dart';
import '../../states/app_user.dart';
import '../../states/app_user_state.dart';
import '../../states/vehicle.dart';
import '../../states/vehicle_state.dart';

class MediaUploader extends ConsumerStatefulWidget {
  const MediaUploader(this.appMedia, {super.key});

  final AppMedia appMedia;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploaderState();
}

class _UploaderState extends ConsumerState<MediaUploader> {
  late AppUser? appuser;
  late AddMediaState state;
  UploadTask? uploadTask;
  late Vehicle vehicle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  appuser = ref.read(appUserProvider);
    // vehicle = ref.read(currentVehicleProvider);
    //  state = ref.read(addMediaStateProvider);
    //  final fileName = path.basename(widget.appMedia.mediaFile.path);

    // final Reference firebaseStorageRef = FirebaseStorage.instance
    //     .ref()
    //     .child('userdata/${appuser?.uuid}/images/$fileName');
  }

  Future<void> startUpload() async {
    _uploadImage();
  }

  void _uploadImage() async {
    //name of the file
    final fileName = path.basename(widget.appMedia.mediaFile.path);

    final Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('userdata/${appuser?.uuid}/images/$fileName');

    uploadTask = firebaseStorageRef.putFile(widget.appMedia.mediaFile);

    await uploadTask?.whenComplete(() async {
      widget.appMedia.downloadUrl = await firebaseStorageRef.getDownloadURL();
      print('File uploaded to Firebase at ${widget.appMedia.downloadUrl}');

//update the [downloadUrl]  and set the vehicle document
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(appuser?.uuid)
          .collection('vehicles')
          .doc(vehicle.id);

          vehicle.images?.insert(0, widget.appMedia.downloadUrl) ;
      // docRef.set({'images': widget.appMedia.downloadUrl});
      await docRef.set(
      vehicle.toMap(),
        SetOptions(merge: true),
      );

      ref.refresh(currentVehicleProvider);
      // Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    appuser = ref.read(appUserProvider);
    vehicle = ref.read(currentVehicleProvider);
    state = ref.watch(addMediaStateProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 80,
          width: 140,
          child: Container(
            decoration: BoxDecoration(
              // color: backgroundColor,
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Image.file(
              widget.appMedia.mediaFile,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Spacer(
          flex: 8,
        ),
        IconButton(
            onPressed: startUpload,
            icon: Icon(
              Icons.cloud_upload,
              color: Colors.blue,
              size: 30,
            )),
        Spacer(flex: 1),
        uploadTask == null
            ? IconButton(
                onPressed: startUpload,
                icon: Icon(
                  Icons.cancel,
                  color: Colors.black87,
                  size: 30,
                ))
            : LinearProgressIndicator(
                value: uploadTask!.snapshot.bytesTransferred.toDouble()),
        Divider(),
      ],
    );

    // StreamBuilder(
    //   stream: uploadTask?.snapshotEvents,
    //   // initialData: initialData,
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     double progressPercent = uploadTask!.snapshot.bytesTransferred /
    //         uploadTask!.snapshot.totalBytes;
    //     return Container(
    //       child: LinearProgressIndicator(
    //         color: Colors.blue,
    //         value: progressPercent,
    //       ),
    //     );
    //   },
    // ):IconButton(onPressed: _uploadImage, icon: Icon(Icons.cloud_upload));
  }
}
