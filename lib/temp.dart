// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:fleet_manager_pro/states/vehicle_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as Path;
// import '../../states/app_user_state.dart';
// import '../../states/vehicle.dart';



// class AddMediaDialog extends ConsumerStatefulWidget {
//   const AddMediaDialog({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _AddMediaDialogState();
// }

// class _AddMediaDialogState extends ConsumerState<AddMediaDialog> {
// late Vehicle vehicle;

//    void _pickImage({required ImageSource imageSource}) async {
//     final pickedFile = await ImagePicker().pickImage(source: imageSource);
//     if (pickedFile != null) {
//       final file = File(pickedFile.path);
//       _uploadImage(file);
//     }
//    void _pickMultiImage({required ImageSource imageSource}) async {
//     final pickedFile = await ImagePicker().pickImage(source: imageSource);
//     if (pickedFile != null) {
//       final file = File(pickedFile.path);
//       _uploadImage(file);
//     }
    
//   }

//   void _uploadImage(File file) async {
//     final appuser = ref.read(appUserProvider);
//     final vehicle = ref.read(currentVehicleProvider);
//     final fileName = Path.basename(file.path);
//     final Reference firebaseStorageRef = FirebaseStorage.instance
//         .ref()
//         .child('userdata/${appuser?.uuid}/images/$fileName');
//     final UploadTask uploadTask = firebaseStorageRef.putFile(file);
//     await uploadTask.whenComplete(() async {
//       final String downloadURL = await firebaseStorageRef.getDownloadURL();
//       print('File uploaded to Firebase at $downloadURL');
//       final DocumentReference docRef = FirebaseFirestore.instance
//           .collection('users')
//           .doc(appuser?.uuid)
//           .collection('vehicles')
//           .doc(vehicle.id);
//       final List<String> imagesList = List<String>.from(state.images ?? []);
//       imagesList.add(downloadURL);
//       await docRef.update({'images': imagesList});
//       ref.refresh(currentVehicleProvider);
//       Navigator.pop(context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//      vehicle = ref.watch(currentVehicleProvider);
//     return Dialog(
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               children: [
//                                 Expanded(flex: 1,
//                                   child: Container(color:Colors.blue,
//                                   // height: 10,
//                                   child: Text('continer'),)),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         IconButton(
//                                           onPressed: () async {
//                                             _pickImage(
//                                                 imageSource: ImageSource.camera);
//                                           },
//                                           icon: Icon(
//                                             Icons.camera,
//                                             size: 45,
//                                           ),
//                                         ),
//                                         Text('Take Photo'),
//                                       ],
//                                     ),
//                                     Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         IconButton(
//                                           onPressed: () async {
//                                             _pickImage(
//                                                 imageSource: ImageSource.gallery);
//                                           },
//                                           icon: Icon(
//                                             Icons.photo_album,
//                                             size: 45,
//                                           ),
//                                         ),
//                                         Text('Choose from Gallery'),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//   }
// }


//   }