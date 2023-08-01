import 'package:equatable/equatable.dart';
import 'package:fleet_manager_pro/states/barrel_states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addedMediaProvider =
    StateNotifierProvider<AddedMediaNotifier, AddedMedia>((ref) {
  final appUser = ref.read(appUserProvider);
  return AddedMediaNotifier();
});

class AddedMedia extends Equatable {
  final List<Media> addedMedia;

  const AddedMedia({
    required this.addedMedia,
  });

  AddedMedia copyWith({
    List<Media>? addedMedia,
  }) {
    return AddedMedia(
      addedMedia: addedMedia ?? this.addedMedia,
    );
  }

  @override
  List<Object?> get props => [addedMedia];
}

class AddedMediaNotifier extends StateNotifier<AddedMedia> {
  AddedMediaNotifier() : super(const AddedMedia(addedMedia: []));

  void addMedia(Media media) {
    final newMediaList = [...state.addedMedia, media];
    state = state.copyWith(addedMedia: newMediaList);
  }

  void setAddedMedia(List<Media> mediaList) {
    state = state.copyWith(addedMedia: mediaList);
  }

void clearMedia(){
  state.addedMedia.clear();
  state= state;

}
 
  void updateMediaUrl(Media media){
    int index = state.addedMedia.indexOf(media);
    print('at index of  $index existing url quals ${state.addedMedia[index].url}');
    state.addedMedia.replaceRange(index, index,[ media ]);
    print('at index of $index new url quals ${state.addedMedia[index].url}');
    state.copyWith();
  }
}
