import 'package:fleet_manager_pro/app.dart';
import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/states/flexscheme_state.dart';
import 'package:fleet_manager_pro/ui/shared/loading_overlay.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
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
            currentAccountPicture:
                ClipOval(child: Image.network(appUser.photoUrl!)),
            currentAccountPictureSize: const Size.square(72),
          ),
          const ProfileTile(),
          const Divider(),
          ThemeModeTile(),
          const Divider(),
          ThemesTile(),
          const Divider(),
          // const SettingsTile(),
          // const Divider(),
          const AboutTile(),
          const Divider(),
          const SignOutTile(),
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
    return SwitchListTile(
      value: themeMode==ThemeMode.dark,
      secondary: Icon(
        (Icons.dark_mode),
        color: Theme.of(context).colorScheme.primary,
        // size: 40,
      ),
      onChanged: (value) {
        onChanged(value);
      },
      title: Text(
        'Dark Mode',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      // trailing:
      //     Switch(value: themeMode == ThemeMode.dark, onChanged: onChanged),
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
      // hoverColor: Colors.green,
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
        final appInfo = AppVersionInfo();
        showAboutDialog(
            context: context,
            applicationName: 'Fleet Manager Pro',
            applicationVersion: appInfo.version,
            children: [
              const Text('Powered By'),
              Text(appInfo.poweredBy),
              const Text('a single man startup by'),
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
  Widget build(BuildContext context, WidgetRef ref) {
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
        ref.read(appUserProvider.notifier).clearUser();
      },
    );
  }
}

class ThemesTile extends ConsumerWidget {
  ThemesTile({
    super.key,
  });
  late WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    this.ref = ref;
    return ListTile(
      onTap: () {
        showDialog(context: context, builder: themesDialogBuilder);
      },
      leading: Icon(
        (Icons.color_lens),
        color: Theme.of(context).colorScheme.primary,
        // size: 40,
      ),
      title: Text(
        'Themes',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget themesDialogBuilder(BuildContext context) {
    final currentScheme = ref.watch(flexSchemeProvider);
    bool  isLoading =false;

    return Stack(
      children: [
        SimpleDialog(
          title: const Text('Choose Theme'),
          insetPadding: const EdgeInsets.all(8),
          children: FlexScheme.values
              .map(
                (e) => ListTile(
                  title: Text(e.name),
                  trailing: currentScheme == e ? const Icon(Icons.check) : null,
                  onTap: () async {
                    Navigator.pop(context);
                    isLoading=true;
                    ref.read(flexSchemeProvider.notifier).changeScheme(e);
                    await Future.delayed(const Duration(milliseconds: 5000));
                  },
                ),
              )
              .toList(),
        ),
        LoadingOverlay(isLoading: isLoading),
      ],
    );
  }
}
