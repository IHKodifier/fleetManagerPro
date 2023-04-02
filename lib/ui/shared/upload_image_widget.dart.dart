import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class UploadImageWidget extends ConsumerStatefulWidget {
  final ImageSource imageSource;

  UploadImageWidget({required this.imageSource});

  @override
  _UploadImageWidgetState createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends ConsumerState<UploadImageWidget> {
  final picker = ImagePicker();

  void _uploadImage(File file) async {
    final fileName = Path.basename(file.path);
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/$fileName');
    final UploadTask uploadTask = firebaseStorageRef.putFile(file);
    await uploadTask.whenComplete(() => print('File uploaded to Firebase'));
  }

  void _pickImage() async {
    final pickedFile = await picker.pickImage(source: widget.imageSource);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      _uploadImage(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _pickImage,
      child: Text('Pick Image'),
    );
  }
}
