import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../app.dart';
import '../../states/barrel_models.dart';
import '../../states/barrel_states.dart';
import '../shared/add_media_dialog.dart';

class ProfileEditView extends ConsumerStatefulWidget {
 
   ProfileEditView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends ConsumerState<ProfileEditView> {
 final TextEditingController displayNameController= TextEditingController();
  final TextEditingController profileTypeController= TextEditingController();
  final TextEditingController cityLoctionController= TextEditingController();
  final TextEditingController phoneController= TextEditingController();
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
  Widget build(BuildContext context, ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body:  ProfileBody(displayNameController: this.displayNameController,
      phoneController: this.phoneController,
      profileTypeController: this.profileTypeController,
      cityLocationController: this.cityLoctionController,
      ),
  
    );
  }
}













class ProfileBody extends ConsumerWidget {
  final displayNameController,profileTypeController,cityLocationController,phoneController;
  const ProfileBody({this.displayNameController, this.profileTypeController, this.cityLocationController, this.phoneController, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                const SizedBox(height: 12,),
                IconButton(onPressed: () {
                  showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: AddMediaDialog(),
                        ),
                      );
                }, icon: const Icon(Icons.add_a_photo)),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 70,
        ),
         ProfileColumnView(displayNameController:this.displayNameController,
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
              ? Stack(
                  children: [
                    Image.network(user.photoUrl!),
                    IconButton(
                        onPressed: _addProfilePhoto,
                        icon: const Center(
                            child: Icon(
                          Icons.add_a_photo,
                          size: 40,
                        ))),
                  ],
                )
              : Image.network(user.photoUrl!),
        )),
      ),
    );
  }

  void _addProfilePhoto() {}
}



class ProfileColumnView extends ConsumerWidget {
   final displayNameController,
      profileTypeController,
      cityLocationController,
      phoneController;
      late AppUser  previousUserState,newUserState;
   ProfileColumnView({this.displayNameController, this.profileTypeController, this.cityLocationController, this.phoneController, super.key});
       var formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final  previousUserState= ref.read(appUserProvider);
    displayNameController.text = previousUserState?.displayName!;
    profileTypeController.text = previousUserState?.profileType!;
    cityLocationController.text = previousUserState?.location!;
    phoneController.text = previousUserState?.phone!;
    newUserState= previousUserState!.copyWith();
    // final user = ref.watch(appUserProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Form(
        key: formKey,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            TextFormField(
              controller: displayNameController,
              onSaved: (newValue) {
                newUserState.displayName=newValue;
              },
              decoration: InputDecoration(
                label: Text('Display Name'),
                // hintText: 'Display Nam',
                
              ),

            ),
            SizedBox(height: 8,),
            TextFormField(
              controller: profileTypeController,
              onSaved: (newValue) {
                newUserState.profileType=newValue;
              },
              decoration: InputDecoration(
                label: Text('Profile Type'),
                hintText: 'e.g. Individual or Business',
              ),

            ),
            SizedBox(height: 8,),
            TextFormField(
              controller: cityLocationController,
              onSaved: (newValue) {
                newUserState.location=newValue;
              },
              decoration: InputDecoration(
                label: Text('City/Area'),
                hintText: 'Optional',
              ),

            ),
            SizedBox(height: 8,),
            TextFormField(
              controller: phoneController,
              onSaved: (newValue) {
                newUserState.phone=newValue;
              },
              decoration: InputDecoration(
                label: Text('Phone '),
                hintText: 'Optional',
              ),

            ),
            SizedBox(height: 8,),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () {}, child: 
                Text('Reset'))),
                SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: () => _updateProfile(context,ref), child: 
                Text('Save'))),
              ],
            ),

         
          ],
        ),
      ),
    );
  }

  void _updateProfile(BuildContext context,WidgetRef ref) async  {
    formKey.currentState?.save();
    Logger logger=Logger();
    logger.i(newUserState.toString());

    await FirebaseFirestore.instance.collection('users').doc(newUserState.uuid)
    .set(newUserState.toMap(),SetOptions(merge: true));
                    ref.read(appUserProvider.notifier).setAppUser(newUserState);

    Navigator.pop(context);
  }
}
