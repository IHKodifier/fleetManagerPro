import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddMediaState {
  AddMediaState({
    required this.media,
  });

  List<Media> media = [];

  AddMediaState copyWith({
    List<Media>? media,
  }) {
    return AddMediaState(
      media: media ?? this.media,
    );
  }
}





class Media {
  Media(
     this.file,{
    this.downloadUrl,
  });

  String? downloadUrl;
  late File file;

  Media fromXfile(XFile xFile)=>Media(xFile as File);

  Media copyWith({
     File? file,
    String? downloadUrl,
  }) {
    return Media(
      file ?? this.file,
      // downloadUrl ?? this.downloadUrl,
    );
  }
}

final addMediaStateProvider =
    StateNotifierProvider<AddMediaNotifier, AddMediaState>((ref) {
  return AddMediaNotifier(AddMediaState(media: []));
});



class AddMediaNotifier extends StateNotifier<AddMediaState> {
  AddMediaNotifier(AddMediaState state) : super(state);

  void addMedia(Media media){
    var fileList = state.media;
    fileList.insert(0, media);

    state=state.copyWith(media: fileList);
    // state.media.insert(0, media);
    state = state;
  }
  void setMedia(List <Media> media){
    state=state.copyWith(media: media);
  }
}