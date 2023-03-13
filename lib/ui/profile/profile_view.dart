import 'package:fleet_manager_pro/ui/profile/profile_edit.dart';
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
          onPressed: onFABPressed,
          icon: const Icon(Icons.edit)),
    );
  }

  void onFABPressed() {
    Navigator.of(localContext).push(
        MaterialPageRoute(builder: (localContext) => const ProfileEditView()));
  }
}

class ProfileBody extends ConsumerWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return Center(
      child: ListView(
          // padding: const EdgeInsets.all(12),
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: const [
                ProfileBanner(),
                ProfileNameonBanner(),
                Positioned(
                  bottom: -86,
                  left: 0,
                  right: 0,
                  child: ProfileAvatar(),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            const ProfiileFormView(),
          ]),
    );
  }
}

class ProfileNameonBanner extends StatelessWidget {
  const ProfileNameonBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
          padding:
              const EdgeInsets.only(left: 12, right: 24, top: 12, bottom: 12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black87,
                Colors.black45,
              ],
            ),
            borderRadius: BorderRadius.only(
              // topRight: Radius.circular(12),
              bottomRight: Radius.circular(100),
            ),
          ),
          child: Text(
            'Dev Cycle Tester',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          )),
    );
  }
}

class Individual extends ConsumerWidget {
  const Individual({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: const Center(child: Text('Individual')),
    );
  }
}

class Business extends ConsumerWidget {
  const Business({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: const Center(child: Text('Business')),
    );
  }
}

class ProfileBanner extends ConsumerWidget {
  const ProfileBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final curatedHeight = size.width / 1.618;
    // final aspectRtio = size.width / curatedHeight;
    return AspectRatio(
        aspectRatio: 1.618,
        child: Image.network(
            'https://picsum.photos/${size.width.toInt().toString()}/${curatedHeight.toInt().toString()}'));
  }
}

class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CircleAvatar(
      radius: 86,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 80,
        child: ClipOval(child: Image.network('https://i.pravatar.cc/300')),
      ),
    );
  }
}

class ProfiileFormView extends ConsumerWidget {
  const ProfiileFormView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Dev Cycle Tester',
                style: Theme.of(context).textTheme.headlineLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.assignment_outlined,
                  size: 35,
                ),
                const Spacer(
                  flex: 1,
                ),
                Text(
                  'Individual ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(flex: 6),
                // const Spacer(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 35,
                ),
                const Spacer(),
                Text(
                  'Islamabad ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(
                  flex: 6,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.call,
                  size: 35,
                ),
                const Spacer(),
                Text(
                  '+92 333 598 9810',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(
                  flex: 6,
                ),
              ],
            ),

            // TextFormField(
            //   decoration: const InputDecoration(
            //       label: Text(
            //         'Profile Name',
            //       ),
            //       hintText: 'Name of your profile'),
            // ),
            // TextFormField(
            //   decoration: const InputDecoration(
            //       label: Text(
            //         'Profile Name',
            //       ),
            //       hintText: 'Name of your profile'),
            // ),
          ],
        ),
      ),
    );
  }
}
