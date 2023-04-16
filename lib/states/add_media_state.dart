import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddMediaState {
  AddMediaState({
    required this.media,
  });

  List<AppMedia> media = [];

  AddMediaState copyWith({
    List<AppMedia>? media,
  }) {
    return AddMediaState(
      media: media ?? this.media,
    );
  }
}

final addMediaProvider =
    StateNotifierProvider<AddMediaNotifier, AddMediaState>((ref) {
  return AddMediaNotifier(AddMediaState(media: []));
});

class AddMediaNotifier extends StateNotifier<AddMediaState> {
  AddMediaNotifier(AddMediaState state) : super(state);

  void addMedia(AppMedia media) {
    var fileList = state.media;
    fileList.insert(0, media);

    state = state.copyWith(media: fileList);
    state = state;
  }

  void setDownloadUrl(AppMedia appMedia, String downloadUrl) {
    for (var item in state.media) {
      if (item.mediaFile == appMedia.mediaFile) {
        item.setUrl(downloadUrl);
      }
    }
  }

  void setMedia(List<AppMedia> media) {
    state = state.copyWith(media: media);
  }
}
