// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/vehicle.dart';
import 'package:fleet_manager_pro/states/vehicle_state.dart';
import 'package:fleet_manager_pro/ui/shared/barrel_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import '../../states/maintenance_state.dart';
import '../../states/maintenances.dart';
import '../shared/image_pageview.dart';
import '../shared/maintenance_card.dart';

class VehicleDetailScreen extends ConsumerStatefulWidget {
  const VehicleDetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends ConsumerState<VehicleDetailScreen> {
  late final imagePageController;
  late AsyncValue<List<Maintenance>> maintenanceAsync;
  late int selectedPage;
  late Vehicle state;
  double newDriven = 0;

  late BuildContext _context;

  @override
  void initState() {
    // TODO: implement initState
    selectedPage = 0;
    imagePageController = PageController(initialPage: selectedPage);
    state = ref.read(currentVehicleProvider);
    newDriven = state.driven!.toDouble();
    super.initState();
  }

  void onFABPressed() {}

  body(BuildContext context) {
    // state = ref.watch(currentVehicleProvider);
    final pageCount = state.images!.length;
    _context = context;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: false,
          floating: true,
          backgroundColor: Colors.transparent,
          expandedHeight: 200,
          // snap: true ,
          flexibleSpace: FlexibleSpaceBar(
              background: imagePageViewContainer(pageCount),
              collapseMode: CollapseMode.parallax,
              title: Container(
                width: double.infinity,
                child: DecoratedBox(
                    decoration:  BoxDecoration(
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
                        Spacer(),
                        Text(state.reg!,
                        style: Theme.of(context).textTheme.titleMedium,),
SizedBox(width: 8,),
                      ],
                    )),
              )),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // displays the make and model of th vehicle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.make!,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    state.model!,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              // displays the year and doors of the vehicle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.year!,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    '${state.doors.toString()} dr',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 20),
                  ),
                ],
              ),
              // displays the driven and button to update the driven  of the vehicle

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.driven.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 18),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    ' Kms',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: updateDrivenDialogBuilder);
                      },
                      icon: const Icon(Icons.edit))
                ],
              ),
            ],
          ),
        ),
        maintenanceAsync.when(
          error: (error, stackTrace) {
            print(error.toString());
            print(stackTrace.toString());
            return Text('Error: $error');
          },
          loading: () {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const Center(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )),
                childCount: 5,
              ),
            );
          },
          data: (maintenances) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  print(
                      'length of msintenances = ${maintenances.length.toString()}');
                  final maintenance = maintenances[index];
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      height: 150,
                      child: MaintenanceCard(
                        state: maintenance,
                        totalDriven: ref.read(currentVehicleProvider).driven!,
                      ),
                    ),
                  );
                },
                childCount: maintenances.length,
              ),
            );
          },
        ),
        //
      ],
    );
  }

  Widget imagePageViewContainer(int pageCount) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          state.images!.isEmpty
              ? Container(
                  color: Colors.blueGrey.shade300,
                  child: const Center(
                      child: Text(
                          'No Media added for this car , click the camer Icon below to add Media for this car')),
                )
              : imagePageView(),
          state.images!.isEmpty
              ? Container()
              : ImagePageViewDotIndicator(
                  selectedPage: selectedPage, pageCount: pageCount),
        ],
      ),
    );
  }

  PageView imagePageView() {
    return PageView(
      onPageChanged: (value) => setState(() {
        selectedPage = value;
      }),
      controller: imagePageController,
      children: state.images!
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  fit: BoxFit.fitHeight,
                  e!,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget updateDrivenDialogBuilder(BuildContext context) {
    return AlertDialog(
      title: Text('Update  driven'),
      content: SpinBox(
        min: state.driven!.toDouble(),
        max: 2000000,
        value: newDriven,
        onChanged: (value) => setState(() {
          newDriven = value;
          state = state.copyWith(driven: newDriven.toInt());
        }),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ),
        Spacer(),
        ElevatedButton(
            onPressed: _updateDriven,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text('Save'),
            )),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    state = ref.watch(currentVehicleProvider);
    maintenanceAsync = ref.watch(maintenanceStreamProvider(state.id));
    return Scaffold(
      body: body(context),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Maintenance'),
        onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const AddMaintenanceScreen())),
      ),
    );
  }

  Future<void> _updateDriven() async {
    if (kDebugMode) {
      print(state.driven.toString());
    }
    final vehicledocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(appUserProvider)?.uuid)
        .collection('vehicles')
        .doc(ref.read(currentVehicleProvider).id);

    await vehicledocRef
        .set({'driven': newDriven.toInt()}, SetOptions(merge: true));
    Navigator.of(context).pop();

    ref.read(currentVehicleProvider.notifier).updateDriven(newDriven.toInt());
  }
}

@override
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(currentVehicleProvider);
  return TextButton(
    onPressed: () {},
    child: Text(
      '${state.driven}  kms',
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: Colors.white70),
      // );,
      // ),
    ),
  );
}
