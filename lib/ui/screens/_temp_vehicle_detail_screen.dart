// import 'package:fleet_manager_pro/states/barrel_models.dart';
// import 'package:fleet_manager_pro/ui/shared/image_pageview.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../states/barrel_states.dart';
// import '../../states/maintenance_state.dart';

// class tempVehicleDetailScreen extends ConsumerStatefulWidget {
//   const tempVehicleDetailScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _VehicleDetailScreenState();
// }

// class _VehicleDetailScreenState extends ConsumerState<tempVehicleDetailScreen> {
//   Vehicle vehicleState = Vehicle(id: '998');
//   var maintenanceAsync;
//   late Widget bannerImage;
//   late int selectedImagePage;

//   @override
//   Widget build(BuildContext context) {
//     vehicleState = ref.watch(currentVehicleProvider);
//     maintenanceAsync = ref.watch(maintenanceStreamProvider(vehicleState.id));

    // var tabs = [
    //   Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       children: [
    //         Icon(
    //           Icons.car_repair,
    //           color: Theme.of(context).colorScheme.primary,
    //           size: 40,
    //         ),
    //         Text(
    //           'Maintances',
    //           style: Theme.of(context).textTheme.titleSmall,
    //         ),
    //       ],
    //     ),
    //   ),
    //   Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       children: [
    //         Icon(
    //           Icons.local_gas_station_rounded,
    //           color: Theme.of(context).colorScheme.primary,
    //           size: 40,
    //         ),
    //         Text(
    //           'Fuel Stops',
    //           style: Theme.of(context).textTheme.titleSmall,
    //         ),
    //       ],
    //     ),
    //   ),
    //   Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       children: [
    //         Icon(
    //           Icons.location_pin,
    //           color: Theme.of(context).colorScheme.primary,
    //           size: 40,
    //         ),
    //         Text(
    //           'Log Book',
    //           style: Theme.of(context).textTheme.titleSmall,
    //         ),
    //       ],
    //     ),
    //   ),
    // ];

    // var tabViews = [
    //   ListView.builder(
    //     itemCount: 25,
    //     itemBuilder: (context, index) => ListTile(
    //       title: Text(
    //         'Maintenance $index',
    //       ),
    //     ),
    //   ),
    //   ListView.builder(
    //     itemCount: 25,
    //     itemBuilder: (context, index) => ListTile(
    //       title: Text('Fuel stop  $index'),
    //     ),
    //   ),
    //   ListView.builder(
    //     itemCount: 25,
    //     itemBuilder: (context, index) => ListTile(
    //       title: Text(
    //           // index.toString(),
    //           'Log  $index'),
    //     ),
    //   ),
    // ];

//     bannerImage = SizedBox(
//       height: 250,
//       child: Stack(
//         children: [
//           vehicleState.images!.isEmpty
//               ? Container(
//                   color: Theme.of(context).colorScheme.secondary,
//                   child: Center(
//                       child: Padding(
//                     padding: const EdgeInsets.all(32.0),
//                     child: Text(
//                       'No Media added for this car , click the camer Icon below to add Media for this car',
//                       textAlign: TextAlign.center,
//                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                           color: Theme.of(context).colorScheme.onSecondary),
//                     ),
//                   )),
//                 )
//               : imagePageView(),
//           vehicleState.images!.isEmpty
//               ? Container()
//               : ImagePageViewDotIndicator(
//                   selectedPage: selectedImagePage, pageCount: pageCount),
//           Positioned(
//             bottom: 8,
//             left: 8,
//             child: IconButton(
//               icon: Icon(
//                 Icons.add_a_photo,
//                 color: Theme.of(context).colorScheme.onPrimary,
//                 size: 45,
//               ),
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => Dialog(
//                     child: AddMediaDialog(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );

//     SliverAppBar sliverAppBar = SliverAppBar(
//       pinned: false,
//       floating: true,
//       backgroundColor: Colors.transparent,
//       expandedHeight: 200,
//       // snap: true ,
//       flexibleSpace: FlexibleSpaceBar(
//           // background: imagePageViewContainer(vehicleState.images?.length),
//           background: imagePageViewContainer(),
//           collapseMode: CollapseMode.parallax,
//           title: SizedBox(
//             width: double.infinity,
//             child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Theme.of(context).colorScheme.background,
//                       Colors.transparent,
//                     ],
//                     begin: Alignment.centerRight,
//                     end: Alignment.center,
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Spacer(),
//                     Text(
//                       // vehicleState.reg!,
//                       'uncomment this text',
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     const SizedBox(
//                       width: 8,
//                     ),
//                   ],
//                 )),
//           )),
//       centerTitle: true,
//     );

//     SliverToBoxAdapter vehicleInfoBlock = SliverToBoxAdapter(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // displays the make and model of th vehicle
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 // vehicleState.make!,
//                 'uncomment',
//                 style: Theme.of(context).textTheme.headlineLarge,
//               ),
//               const SizedBox(
//                 width: 12,
//               ),
//               Text(
//                 // vehicleState.model!,
//                 'uncomment',

//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//             ],
//           ),
//           // displays the year and doors of the vehicle
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 // vehicleState.year!,
//                 'uncomment',

//                 style: Theme.of(context)
//                     .textTheme
//                     .labelLarge!
//                     .copyWith(fontSize: 20),
//               ),
//               const SizedBox(
//                 width: 12,
//               ),
//               Text(
//                 // '${vehicleState.doors.toString()} dr',

//                 'uncomment',
//                 style: Theme.of(context)
//                     .textTheme
//                     .labelLarge!
//                     .copyWith(fontSize: 20),
//               ),
//             ],
//           ),
//           // displays the driven and button to update the driven  of the vehicle

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 // vehicleState.driven.toString(),
//                 'uncomment',

//                 style: Theme.of(context)
//                     .textTheme
//                     .labelLarge!
//                     .copyWith(fontSize: 18),
//               ),
//               const SizedBox(
//                 width: 12,
//               ),
//               Text(
//                 ' Kms',
//                 style: Theme.of(context)
//                     .textTheme
//                     .labelLarge!
//                     .copyWith(fontSize: 18, fontStyle: FontStyle.italic),
//               ),
//               IconButton(
//                   onPressed: () {
//                     // showDialog(
//                     //     context: context,
//                     //     builder: updateDrivenDialogBuilder);
//                   },
//                   icon: const Icon(Icons.edit))
//             ],
//           ),
//         ],
//       ),
//     );

    // Widget tabbedLists = SliverFillRemaining(
    //   child: DefaultTabController(
    //     length: 3,
    //     child: Column(children: [
    //       TabBar(tabs: tabs),
    //       Expanded(
    //         child: TabBarView(
    //           children: tabViews,
    //         ),
    //         ListView.builder(
    //           itemCount: 25,
    //           itemBuilder: (context, index) => ListTile(
    //           title: Text(index.toString(),
    //           ),
    //         ),),
    //       ),
    //     ]),
    //   ),
    // );

//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           sliverAppBar,
//           vehicleInfoBlock,
//           tabbedLists,
//         ],
//       ),
//     );
//   }

//   Widget imagePageViewContainer() {
//     return SizedBox(
//       height: 250,
//       child: Stack(
//         children: [
//           vehicleState.images!.isEmpty
//               ? Container(
//                   color: Theme.of(context).colorScheme.secondary,
//                   child: Center(
//                       child: Padding(
//                     padding: const EdgeInsets.all(32.0),
//                     child: Text(
//                       'No Media added for this car , click the camer Icon below to add Media for this car',
//                       textAlign: TextAlign.center,
//                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                           color: Theme.of(context).colorScheme.onSecondary),
//                     ),
//                   )),
//                 )
//               : bannerImage,
//           vehicleState.images!.isEmpty
//               ? Container()
//               : ImagePageViewDotIndicator(
//                   selectedPage: selectedImagePage, pageCount: pageCount),
//           Positioned(
//             bottom: 8,
//             left: 8,
//             child: IconButton(
//               icon: Icon(
//                 Icons.add_a_photo,
//                 color: Theme.of(context).colorScheme.onPrimary,
//                 size: 45,
//               ),
//               onPressed: () {
//                 // showDialog(
//                 //   context: context,
//                 //   builder: (context) => Dialog(
//                 //     child: AddMediaDialog(),
//                 //   ),
//                 // );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
