///[MediaThumbnail]  displays a thumbnail of an image file

import 'package:fleet_manager_pro/states/app_media.dart';
import 'package:fleet_manager_pro/ui/shared/barrel_widgets.dart';

class MediaThumbnail extends StatelessWidget {
  final Media appMedia;

  MediaThumbnail({required this.appMedia});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 50,
      child: Image.file(
        appMedia.mediaFile,
        fit: BoxFit.cover,
      ),
    );
  }
}
