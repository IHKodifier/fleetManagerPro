import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/vehicle.dart';
import 'package:fleet_manager_pro/states/vehicle_state.dart';
import 'package:fleet_manager_pro/ui/shared/barrel_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as Path;
// import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../../states/maintenance_state.dart';
import '../../states/maintenances.dart';
import '../shared/add_media_dialog.dart';
import '../shared/fab_with_dialog.dart';
import '../shared/maintenance_card.dart';
import '../shared/maintenance_list.dart';

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

  late BuildContext _context;

  @override
  void initState() {
    // TODO: implement initState
    selectedPage = 0;
    imagePageController = PageController(initialPage: selectedPage);

    super.initState();
  }

  void onFABPressed() {}

  body(BuildContext context) {
    state = ref.watch(currentVehicleProvider);
    final pageCount = state.images!.length;
    _context = context;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('vehicle details'),
          pinned: false,
          floating: true,
          backgroundColor: Colors.transparent,
          expandedHeight: 200,
          // snap: true ,
          flexibleSpace: FlexibleSpaceBar(
              background: imagePageViewContainer(pageCount),
              collapseMode: CollapseMode.parallax,
              title: Text(state.reg!)),
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
                (context, index) =>
                    Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const CircularProgressIndicator(),
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
                  return Container(
                    height: 150,
                    child: MaintenanceCard(
                      maintenance: maintenance,
                      totalDriven: ref.read(currentVehicleProvider).driven!,
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

  Container imagePageViewContainer(int pageCount) {
    return Container(
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
              : ImadePageViewDotIndicator(
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
              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
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

  @override
  Widget build(BuildContext context) {
    state = ref.watch(currentVehicleProvider);
    maintenanceAsync = ref.watch(maintenanceStreamProvider(state.id));
    return Scaffold(
      body: body(context),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('Add Maintenance'), 
        onPressed:  ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>  const AddMaintenanceScreen())),
      ),
    );
  }
}

class AddCameraButton extends ConsumerWidget {
  const AddCameraButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(
        Icons.add_a_photo,
        size: 45,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: AddMediaDialog(),
          ),
        );
      },
    );
  }
}

class ImadePageViewDotIndicator extends StatelessWidget {
  const ImadePageViewDotIndicator({
    super.key,
    required this.selectedPage,
    required this.pageCount,
  });

  final int pageCount;
  final int selectedPage;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      right: 0,
      left: 0,
      child: PageViewDotIndicator(
        currentItem: selectedPage,
        count: pageCount,
        size: const Size(16, 16),
        unselectedSize: const Size(6, 6),
        selectedColor: Theme.of(context).colorScheme.primary,
        unselectedColor: Colors.blueGrey.shade200,
        duration: const Duration(milliseconds: 200),
        boxShape: BoxShape.circle,
      ),
    );
  }
}

class YearWidget extends StatelessWidget {
  const YearWidget({
    super.key,
    required this.state,
  });

  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return Text(
      state.year!,
      style: Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(color: Colors.white70),
    );
    // );
  }
}

class ModelNameWidget extends StatelessWidget {
  const ModelNameWidget({
    super.key,
    required this.state,
  });

  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return Text(
      state.model!,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(color: Colors.white70),
    );
  }
}

class ManufacLogo extends StatelessWidget {
  const ManufacLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
        'https://www.citypng.com/public/uploads/small/116622223421szbtwasfjdtlwhmbltou4fgm2aixci0syqz9gfsweyschieb1peugcreblyogaewk8uzuybcsojxm8s4stve8e8adipzqa7fapq.png',
        loadingBuilder: (context, child, loadingProgress) {
           if (loadingProgress == null) {
      return child;
    } else {
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              : null,
        ),
      );
    }
        },);
  }
}

class PositionedModelWidget extends StatelessWidget {
  const PositionedModelWidget({
    super.key,
    required this.state,
  });

  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // bottom: ,
      right: 10,
      // left: ,
      top: 10,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          state.model!,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class PositionedYearWidget extends StatelessWidget {
  const PositionedYearWidget({
    super.key,
    required this.state,
  });

  final Vehicle state;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 8,
      child: Text(
        state.year!,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

class UpdateMileageButton extends ConsumerWidget {
  const UpdateMileageButton({super.key});

  _updateMileage(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: ClipOval(
                child: Image.network(
              'https://static.vecteezy.com/system/resources/previews/009/933/333/non_2x/speedometer-kilometers-icon-outline-illustration-vector.jpg',
              loadingBuilder: (context, child, loadingProgress) {
                 if (loadingProgress == null) {
      return child;
    } else {
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              : null,
        ),
      );
    }
              },
            )),
            title: Text('Update Total  Kilometers '),
            content: TextField(
              // controller: _textController,
              decoration: InputDecoration(
                hintText: 'enter Total Kilometers',
              ),
              keyboardType: TextInputType.number,
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Save'),
                onPressed: () {
                  // TODO: Implement save functionality
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(currentVehicleProvider);
    return TextButton(
      onPressed: () {
        _updateMileage(context);
      },
      child: Text(
        state.driven.toString() + '  kms',
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Colors.white70),
        // );,
        // ),
      ),
    );
  }
}
