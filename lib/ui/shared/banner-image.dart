import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/ui/shared/add_media_dialog.dart';
import 'package:fleet_manager_pro/ui/shared/image_pageview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../states/barrel_models.dart';

class imagePageViewContainer extends ConsumerStatefulWidget {
  const imagePageViewContainer(int length, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _imagePageViewContainerState();
}

class _imagePageViewContainerState extends ConsumerState<imagePageViewContainer> with SingleTickerProviderStateMixin {
  late Vehicle vehicleState;
    late final imagePageController;
      late int selectedImagePage;

      @override
      
  void initState() {
    // TODO: implement initState
    super.initState();
      selectedImagePage = 0;
    imagePageController = PageController(initialPage: selectedImagePage);
        vehicleState = ref.read(currentVehicleProvider);

  }

  PageView imagePageView() {
    return PageView(
      onPageChanged: (value) => setState(() {
        selectedImagePage = value;
      }),
      controller: imagePageController,
      children: vehicleState.images!
          .map(
            (e) => ClipRRect(
              // borderRadius: BorderRadius.circular(16),
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
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicleState = ref.watch(currentVehicleProvider);
    int pageCount = vehicleState.images!.length;
     return SizedBox(
      height: 250,
      child: Stack(
        children: [
          vehicleState.images!.isEmpty
              ? Container(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'No Media added for this car , click the camer Icon below to add Media for this car',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  )),
                )
              : imagePageView(),
          vehicleState.images!.isEmpty
              ? Container()
              : ImagePageViewDotIndicator(
                  selectedPage: selectedImagePage, pageCount: pageCount),
          Positioned(
            bottom: 8,
            left: 8,
            child: IconButton(
              icon: Center(
                child: Icon(
                  Icons.add_a_photo,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 45,
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: AddMediaDialog(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}