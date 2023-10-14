import 'package:fleet_manager_pro/states/flexscheme_state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemesList extends ConsumerWidget {
  const ThemesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScheme = ref.watch(flexSchemeProvider);
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: FlexScheme.values.length,
          itemBuilder: (context, index) {
            final scheme = FlexScheme.values[index];
            return 
            ListTile(
                title: Text(scheme.name),
                trailing: currentScheme == scheme ? Icon(Icons.check) : null,
                onTap: () =>
                    ref.read(flexSchemeProvider.notifier).changeScheme(scheme),
              );
            
          },
        ),
      ),
    );
  }
}
