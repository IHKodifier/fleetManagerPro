import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../app.dart';
import '../../states/barrel_models.dart';
import '../../states/barrel_states.dart';
import '../../utils.dart';
import '../shared/add_media_dialog.dart';

final isBusyProvider = StateNotifierProvider<BusyNotifier, bool>((ref) {
  return BusyNotifier(false);
});

class BusyNotifier extends StateNotifier<bool> {
  BusyNotifier(super.state);
  void setBusy() {state = true;
  state = state;}
  void setNotBusy() { state = false;
  state = state;}
}
class ProfileEditView extends ConsumerStatefulWidget {
  ProfileEditView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileEditViewState();
}

class _ProfileEditViewState extends ConsumerState<ProfileEditView> {
  final TextEditingController cityLoctionController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController profileTypeController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    displayNameController.dispose();
    phoneController.dispose();
    profileTypeController.dispose();
    cityLoctionController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: ProfileBody(
        displayNameController: this.displayNameController,
        phoneController: this.phoneController,
        profileTypeController: this.profileTypeController,
        cityLocationController: this.cityLoctionController,
      ),
    );
  }
}




class ProfileBody extends ConsumerWidget {
   ProfileBody(
      {this.displayNameController,
      this.profileTypeController,
      this.cityLocationController,
      this.phoneController,
      super.key});

  final displayNameController,
      profileTypeController,
      cityLocationController,
      phoneController;

       final _uploadProgressStreamController = StreamController<double>();

  Future<void> onProfilePhotoUpload(BuildContext context, File file, String userId, WidgetRef ref) async {
    // final file = File(media.mediaFile.path);
    ref.read(isBusyProvider.notifier).setBusy();
    final fileName = file.path.split('/').last;
    final storageRef = FirebaseStorage.instance.ref(
      'userdata/$userId/uploads/$fileName',
    );
   final  _uploadTask = storageRef.putFile(file);
    _uploadTask!.snapshotEvents.listen((taskSnapshot) {
      final progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
      _uploadProgressStreamController.sink.add(progress);
    });
        await _uploadTask!.whenComplete(() async {
      // _uploadTask.
      _uploadProgressStreamController.close();
      final photoUrl = await storageRef.getDownloadURL();
    ref.read(appUserProvider.notifier).setPhotoUrl(photoUrl);
    // ignore: avoid_print
    print('.............................\n \n $photoUrl');

    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    ref.read(isBusyProvider.notifier).setNotBusy();




  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busyNotifier= ref.read(isBusyProvider.notifier);
    final busyState = ref.watch(isBusyProvider);


    // TODO: implement build
    return Center(
      child: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(
              height: 70,
            ),
            const ProfileAvatar(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () {}, child: const Text('Remove ')),
                const SizedBox(
                  height: 12,
                ),
                IconButton(
                    onPressed: () async {
                      final pickedMedia = await Utils.pickMediafromCamera();
                      //pickedMedia.length will always be 1 . time to crop it
                      var croppedImage =
                          await Utils().cropSquareImage(pickedMedia![0]);
                      // ignore: unused_local_variable
                      var croppedImageFile = await Utils()
                          .createFileFromCroppedFile(croppedImage!);
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Consumer(
                            builder:(context, ref, child) =>  AlertDialog(
                             
                              content: SizedBox(
                                height: 200,
                                child: Image.file(croppedImageFile),
                              ),
                              title: const Center(child: Text('Profile Image')),
                              actions: [
                              
                                ElevatedButton.icon(
                                    onPressed: () {
                                      onProfilePhotoUpload(context,croppedImageFile,
                                          ref.read(appUserProvider)!.uuid,ref);
                                    },
                                    icon: ref.watch(isBusyProvider)
                                        ?  CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary,)
                                        : const Icon(Icons.upload),
                                    label: ref.watch(isBusyProvider)?Text('uploading...'): const Text('upload'))
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon:  
                    const Icon(Icons.add_a_photo)),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 70,
        ),
        ProfileForm(
          displayNameController: this.displayNameController,
          profileTypeController: this.profileTypeController,
          phoneController: this.phoneController,
          cityLocationController: this.cityLocationController,
        ),
      ]),
    );
  }
}

class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({super.key});

  void _addProfilePhoto() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appUserProvider);
    return CircleAvatar(
      radius: 63,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: CircleAvatar(
        radius: 60,
        child: ClipOval(
            child: Center(
          child: user!.photoUrl == ref.read(defaultPhotoUrlProvider)
              ? Image.network(user.photoUrl!)
              : Image.network(user.photoUrl!),
        )),
      ),
    );
  }
}

class ProfileForm extends ConsumerWidget {
  ProfileForm(
      {this.displayNameController,
      this.profileTypeController,
      this.cityLocationController,
      this.phoneController,
      super.key});

  var formKey = GlobalKey<FormState>();
  late AppUser  newUserState;
  final displayNameController,
      profileTypeController,
      cityLocationController,
      phoneController;

  void _updateProfile(BuildContext context, WidgetRef ref) async {
    // previousUserState= ref.read(appUserProvider);
    formKey.currentState?.save();
    newUserState.photoUrl= ref.read(appUserProvider)!.photoUrl;
    Logger logger = Logger();
    logger.i(newUserState.toString());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(newUserState.uuid)
        .set(newUserState.toMap(), SetOptions(merge: true));
    ref.read(appUserProvider.notifier).setAppUser(newUserState);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final previousUserState = ref.read(appUserProvider);
    displayNameController.text = previousUserState?.displayName!;
    profileTypeController.text = previousUserState?.profileType!;
    // new
    cityLocationController.text = previousUserState?.location!;
    phoneController.text = previousUserState?.phone!;
    newUserState = previousUserState!.copyWith();
    // final user = ref.watch(appUserProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: displayNameController,
              onSaved: (newValue) {
                newUserState.displayName = newValue;
              },
              decoration: const InputDecoration(
                label: Text('Display Name'),
                // hintText: 'Display Nam',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: profileTypeController,
              onSaved: (newValue) {
                newUserState.profileType = newValue;
              },
              decoration: const InputDecoration(
                label: Text('Profile Type'),
                hintText: 'e.g. Individual or Business',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: cityLocationController,
              onSaved: (newValue) {
                newUserState.location = newValue;
              },
              decoration: const InputDecoration(
                label: Text('City/Area'),
                hintText: 'Optional',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: phoneController,
              onSaved: (newValue) {
                newUserState.phone = newValue;
              },
              decoration: const InputDecoration(
                label: Text('Phone '),
                hintText: 'Optional',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          formKey.currentState!.reset();
                        }, child: const Text('Reset'))),
                const SizedBox(width: 8),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () => _updateProfile(context, ref),
                        child: const Text('Save'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
