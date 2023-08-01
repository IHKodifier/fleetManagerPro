import 'package:fleet_manager_pro/app.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/ui/screens/profile_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileView extends ConsumerWidget {
  ProfileView({super.key});
  late BuildContext localContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    localContext = context;
    return Scaffold(
      appBar: AppBar(title: const Text('View Profile')),
      body: const ProfileBody(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Edit'),
        icon: const Icon(
          Icons.edit,
          size: 30,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: onFABPressed,
      ),
    );
  }

  void onFABPressed() {
    Navigator.of(localContext)
        .push(MaterialPageRoute(builder: (localContext) => const ProfileEditView()));
  }
}

class ProfileBody extends ConsumerWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Center(
      child: ListView(children: const [
        Column(
          children: [
            SizedBox(
              height: 70,
            ),
            ProfileAvatar(),
          ],
        ),
        SizedBox(
          height: 70,
        ),
        ProfileColumnView(),
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
                    // IconButton(
                    //     onPressed: _addProfilePhoto,
                    //     icon: Center(
                    //         child: Icon(
                    //       Icons.add_a_photo,
                    //       size: 40,
                    //     ))),
                  ],
                )
              : Image.network(
                  user.photoUrl!,
                  fit: BoxFit.cover,
                ),
        )),
      ),
    );
  }
}

class ProfileColumnView extends ConsumerWidget {
  const ProfileColumnView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appUserProvider);
    var formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(user!.displayName!,
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Profile Type',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  user.profileType!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(flex: 3),
                  const Spacer(),
                  Text(
                    'Loctation',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    user.location!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 12,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(
                  flex: 4,
                ),
                Text(
                  'Phone',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(
                  width: 4,
                ),
                const Icon(
                  Icons.call,
                  size: 20,
                ),
                const Spacer(),
                Text(
                  user.phone!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const Spacer(flex: 2),
                // Text(
                //   user.phone!,
                //   style: Theme.of(context).textTheme.titleMedium,
                // ),
                const Spacer(
                  flex: 4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
