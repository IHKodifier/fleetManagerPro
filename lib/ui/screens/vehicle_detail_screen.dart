import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:fleet_manager_pro/states/app_user_state.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/states/vehicle.dart';
import 'package:fleet_manager_pro/states/vehicle_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as Path;
// import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../shared/add_media_dialog.dart';

class VehicleDetailScreen extends ConsumerStatefulWidget {
  const VehicleDetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends ConsumerState<VehicleDetailScreen> {
   late final imagePageController;
  late int selectedPage;
  late Vehicle state;

  late BuildContext _context;

@override
  void initState() {
    // TODO: implement initState
        selectedPage=0;
        imagePageController=PageController(initialPage: selectedPage);

    super.initState();

  }

  void onFABPressed() {}

  body(BuildContext context) {
    state = ref.watch(currentVehicleProvider);
    final pageCount = state.images!.length;
    _context = context;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 2,
            // margin: EdgeInsets.all(16),
            child: Stack(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 350,
                  child: Stack(
                    children: [
                      state.images!.isEmpty?
                      Container(color: Colors.blueGrey.shade300,):
                      PageView(
                        onPageChanged: (value) => setState(() {
                          selectedPage=value;
                        }),
                        controller: imagePageController,
                        children: state.images!
                            .map(
                              (e) => e == ''
                                  ? Container(
                                      color: Color.fromARGB(255, 216, 225, 230),
                                    )
                                  : Image.network(
                                      fit: BoxFit.fitHeight,
                                      e!,
                                    ),
                            )
                            .toList(),
                            
                      ),
                      state.images!.isEmpty?
                      Container(color: Colors.blueGrey.shade50,):Positioned(
                        bottom: 8, right: 0,left: 0,
                        child: PageViewDotIndicator(
                                currentItem: selectedPage, 
                                count: pageCount, 
                                selectedColor: Theme.of(context).colorScheme.primary,
                                 unselectedColor: Theme.of(context).colorScheme.secondary,
                                 duration: const Duration(milliseconds: 200),
                                 boxShape: BoxShape.circle,
                              ),
                      ),

                    ],
                  ),
                ),
                ListTile(
                  tileColor: Colors.transparent,
                  //todo change to cached network image
                  leading: Image.network(
                      'https://www.citypng.com/public/uploads/small/116622223421szbtwasfjdtlwhmbltou4fgm2aixci0syqz9gfsweyschieb1peugcreblyogaewk8uzuybcsojxm8s4stve8e8adipzqa7fapq.png'),
                  title: Text(
                    state.model!,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    state.year!,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        state.driven.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text('Kms'),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  // left: 8,
                  child: ClipOval(
                    child: Container(
                      color: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          size: 45,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>  Dialog(
                              child: AddMediaDialog(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    state = ref.watch(currentVehicleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.make! + ' ' + state.model!),
      ),
      body: body(context),
      //  body: ,
      floatingActionButton: FloatingActionButton(
          onPressed: onFABPressed,
          child: Icon(
            Icons.add,
            size: 40,
          ),
          tooltip: 'Add Maintenance'),
    );
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
