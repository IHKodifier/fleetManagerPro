import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      // backgroundColor: Colors.yellow,
      // width: MediaQuery.of(context).size.width * 0.8,
      elevation: 10,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Dev cycle  Tester',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
            ),
            accountEmail: const Text('S@d.com'),
            currentAccountPicture: Icon(
              Icons.account_circle,
              size: 72,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            currentAccountPictureSize: const Size.square(80),
          ),
          ListTile(
            leading: Icon(
              (Icons.favorite),
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
            title: Text(
              'Favorites',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              (Icons.settings),
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              (Icons.person),
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
            title: Text(
              'profile',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              (Icons.favorite),
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
            title: Text(
              'Favorites',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              (Icons.favorite),
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
            title: Text(
              'Favorites',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              (Icons.favorite),
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
            title: Text(
              'Favorites',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
