import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../../states/barrel_models.dart';

class ImagePageViewDotIndicator extends StatelessWidget {
  const ImagePageViewDotIndicator({
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
        size: const Size(18, 18),
        unselectedSize: const Size(6, 6),
        selectedColor: Theme.of(context).colorScheme.secondary,
        unselectedColor: Colors.blueGrey.shade200,
        duration: const Duration(milliseconds: 200),
        boxShape: BoxShape.circle,
      ),
    );
  }
}
