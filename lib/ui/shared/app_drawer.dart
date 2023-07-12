import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleet_manager_pro/app.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/ui/shared/vehicles_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/profile_view_screen.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(appUserProvider);
    // final user0 = user ??

    return Drawer(
      // backgroundColor: Colors.yellow,
      // width: MediaQuery.of(context).size.width * 0.8,
      elevation: 10,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              appUser!.displayName!,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
            accountEmail: Text(appUser.email!),
            currentAccountPicture: Icon(
              Icons.account_circle,
              size: 72,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            currentAccountPictureSize: const Size.square(80),
          ),
          const ProfileTile(),
          const Divider(),
          ThemeModeTile(),
          const Divider(),
          const FavoritesTile(),
          const Divider(),
          const MyCarsTile(),
          const Divider(),
          const SettingsTile(),
          const Divider(),
          const ShareTile(),
          const Divider(),
          const AboutTile(),
          const Divider(),
          // const SizedBox(
          //   height: 15,
          // ),
          const SignOutTile(),
          // const Divider(),
        ],
      ),
    );
  }
}

class ThemeModeTile extends ConsumerWidget {
  var themeNotifier;

  ThemeModeTile({super.key});

  void onChanged(bool value) {
    if (value == true) {
      themeNotifier.applyDarkTheme();
    } else {
      themeNotifier.applyLightTheme();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    themeNotifier = ref.read(themeModeProvider.notifier);
    return ListTile(
      leading: Icon(
        (Icons.dark_mode),
        color: Theme.of(context).colorScheme.primary,
        // size: 40,
      ),
      title: Text(
        'Dark Mode',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing:
          Switch(value: themeMode == ThemeMode.dark, onChanged: onChanged),
    );
  }
}

class FavoritesTile extends StatelessWidget {
  const FavoritesTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        (Icons.favorite),
        color: Theme.of(context).colorScheme.primary,
        // size: 40,
      ),
      title: Text(
        'Favorites',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        (Icons.settings),
        color: Theme.of(context).colorScheme.primary,
        size: 40,
      ),
      title: Text(
        'Settings',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ProfileView())),
      hoverColor: Colors.green,
      leading: Icon(
        (Icons.person),
        color: Theme.of(context).colorScheme.primary,
        // size: 40,
      ),
      title: Text(
        'profile',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class ShareTile extends StatelessWidget {
  const ShareTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        (Icons.share),
        color: Theme.of(context).colorScheme.primary,
        // size: 40,
      ),
      title: Text(
        'Share',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class AboutTile extends StatelessWidget {
  const AboutTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        (Icons.info_outline),
        color: Theme.of(context).colorScheme.primary,
        // size: 40,
      ),
      onTap: () {
        final appInfo= AppVersionInfo();
        showAboutDialog(context: context,
        applicationName: 'Fleet Manager Pro',
        applicationVersion: appInfo.version,
        children: [
          Text('Powered By'),
          Text(appInfo.poweredBy),
          Text('a single man startup by'),
          Text(appInfo.author),
          
        ]);
        
      },
      title: Text( 
        'About',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class SignOutTile extends ConsumerWidget {
  const SignOutTile({
    super.key,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return ListTile(
      leading: Icon(
        (Icons.logout),
        color: Theme.of(context).colorScheme.primary,
        // size: 40,
      ),
      title: Text(
        'Sign out',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      onTap: () async {
      //   await FirebaseAuth.instance.signOut();
      // ref.read(appUserProvider.notifier).;
      print('signing out user');
      await ref.read(appUserProvider.notifier).signOut();
      print('user signed out successffully');
      },
    );
  }
}

class MyCarsTile extends StatelessWidget {
  const MyCarsTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) =>  VehicleList())),
      leading: Icon(
        (Icons.car_rental),
        color: Theme.of(context).colorScheme.primary,
        // size: 40,
      ),
      title: Text(
        'My Cars',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
