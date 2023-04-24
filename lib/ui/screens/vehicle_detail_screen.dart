import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/states/vehicle.dart';
import 'package:fleet_manager_pro/states/vehicle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import '../shared/add_media_dialog.dart';

class VehicleDetailScreen extends ConsumerStatefulWidget {
  const VehicleDetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends ConsumerState<VehicleDetailScreen> {
  final pageController = PageController(initialPage: 1);
  late Vehicle state = Vehicle(id: '');

  late BuildContext _context;

  void onFABPressed() {}

  body(BuildContext context) {
    _context = context;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 0,
            margin: EdgeInsets.all(16),
            child: Stack(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 350,
                  child: Stack(
                    children: [
                      PageView(
                        controller: pageController,
                        children: state.images!
                            .map(
                              (e) => e == ''
                                  ? Container(
                                      color: Color.fromARGB(255, 216, 225, 230),
                                    )
                                  : Image.network(
                                      fit: BoxFit.contain,
                                      e!,
                                    ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  tileColor: Colors.transparent,
                  leading: Image.network(
                      'https://www.citypng.com/public/uploads/small/116622223421szbtwasfjdtlwhmbltou4fgm2aixci0syqz9gfsweyschieb1peugcreblyogaewk8uzuybcsojxm8s4stve8e8adipzqa7fapq.png'),
                  title: Text(
                    state.model!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    state.year!,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        state.driven.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text('Kms'),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  // left: 8,
                  child: IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      size: 45,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const Dialog(
                          child: AddMediaDialog(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          //
        ],
      ),
    );
  }

  void _pickImage({required ImageSource imageSource}) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      _uploadImage(file);
    }
  }

  void _uploadImage(File file) async {
    final appuser = ref.read(appUserProvider);
    final vehicle = ref.read(currentVehicleProvider);
    final fileName = Path.basename(file.path);
    final Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('userdata/${appuser?.uuid}/images/$fileName');
    final UploadTask uploadTask = firebaseStorageRef.putFile(file);
    
    await uploadTask.whenComplete(() async {
      final String downloadURL = await firebaseStorageRef.getDownloadURL();
      print('File uploaded to Firebase at $downloadURL');
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(appuser?.uuid)
          .collection('vehicles')
          .doc(vehicle.id);
      final List<String> imagesList = List<String>.from(state.images ?? []);
      imagesList.add(downloadURL);
      await docRef.update({'images': imagesList});
      ref.refresh(currentVehicleProvider);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    state = ref.watch(currentVehicleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.make! + ' ' + state.model!),
      ),
      body: body(context),
      //  body: ,
      floatingActionButton: FloatingActionButton(
          onPressed: onFABPressed,
          child: Icon(
            Icons.add,
            size: 40,
          ),
          tooltip: 'Add Maintenance'),
    );
  }
}

class PositionedModelWidget extends StatelessWidget {
  const PositionedModelWidget({
    super.key,
    required this.state,
  });

  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // bottom: ,
      right: 10,
      // left: ,
      top: 10,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          state.model!,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class PositionedYearWidget extends StatelessWidget {
  const PositionedYearWidget({
    super.key,
    required this.state,
  });

  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 8,
      child: Text(
        state.year!,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
