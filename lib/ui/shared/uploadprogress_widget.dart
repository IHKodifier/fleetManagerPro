///[MediaUploadProgressWidget]displays the progress of an upload



import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:fleet_manager_pro/ui/shared/barrel_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/upload_progress_state.dart';

class MediaUploadProgressWidget extends ConsumerWidget {
  const MediaUploadProgressWidget({Key? key, required this.appMedia})
      : super(key: key);

  final Media appMedia;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.read(appUserProvider);


  final uploadNotifier  = ref.watch(mediaUploadProgressProviderFamily(appMedia).notifier);
 return StreamBuilder<double>(
  stream: uploadNotifier.uploadProgressStream,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      // Show upload icon when the stream has not started
      return IconButton(
        icon: const Icon(Icons.cloud_upload),
        onPressed: () => uploadNotifier.startUpload(),
      );
    } else if (snapshot.connectionState == ConnectionState.active) {
      if (snapshot.hasData) {
        // Show LinearProgressIndicator with value and text when the stream has produced data
        final progressValue = snapshot.data!;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progressValue * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      } else {
        // Show indefinite CircularProgressIndicator when the stream is active and has not yet produced data
        return const Center(child: CircularProgressIndicator());
      }
    } else {
      // Show checkmark icon when the stream is closed
      return  Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Icon(Icons.check_circle,color: Colors.green.shade900,),
              Text('Uploaded',
               style: const TextStyle(fontSize: 12),)
            ],
          ),
          Column(
            children: [
              Icon(Icons.delete_forever,color: Color.fromARGB(255, 112, 8, 1),),
              Text('Delete',
               style: const TextStyle(fontSize: 12),)
            ],
          ),
        ],
      );
    }
  },
);



  }

  IconButton uploadButton(MediaUploadProgressNotifier uploadNotifier) {
    return IconButton(
        icon: const Icon(Icons.cloud_upload),
        onPressed: () => uploadNotifier.startUpload(),
      );
  }
}
