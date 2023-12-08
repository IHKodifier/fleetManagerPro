import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/ui/shared/banner-image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/barrel_models.dart';

class CustomSliverAppBar extends ConsumerWidget {
  const CustomSliverAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.read(currentVehicleProvider);
    return SliverAppBar(
          pinned: false,
          floating: true,
          backgroundColor: Colors.transparent,
          expandedHeight: 200,
          iconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).colorScheme.onBackground),
          // snap: true ,
          flexibleSpace: FlexibleSpaceBar(
              background: imagePageViewContainer(vehicleState.images!.length),
              collapseMode: CollapseMode.parallax,
              title: SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.background,
                          Colors.transparent,
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.center,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        Text(
                          vehicleState.reg!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    )),
              )),
          centerTitle: true,
        );
  }
}