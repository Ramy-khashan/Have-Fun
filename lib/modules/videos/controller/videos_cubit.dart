import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/modules/videos/model/video_model.dart';
import 'package:video_player/video_player.dart';

part 'videos_state.dart';

class VideosCubit extends Cubit<VideosState> {
  VideosCubit() : super(VideosInitial());
  late VideoPlayerController videoController;
  static VideosCubit get(context) => BlocProvider.of(context);
  bool isLoadingGetVideo = false;
  getVideos() async {
    isLoadingGetVideo = true;
    emit(LoadingGetVideoState());
    try {
      await FirebaseFirestore.instance.collection("video").get().then(
        (value) {
          log("lol");
          if (value.docs.isEmpty) {
            log("lol222");
            videoList = [];
            isLoadingGetVideo = false;
            emit(SuccessGetVideoState());
          } else {
            for (var element in value.docs) {
              log("lol1");

              videoList.add(VideoModel.fromJson(element.data()));
            }
            intializeVideo(selectedIndex: 0);
            isLoadingGetVideo = false;
            emit(SuccessGetVideoState());
          }
        },
      ).onError((error, stackTrace) {
        isLoadingGetVideo = false;
        emit(FaildGetVideoState());
      });
    } catch (e) {
      isLoadingGetVideo = false;
      emit(FaildGetVideoState());
    }
  }

  List<VideoModel> videoList = [];
  // List<String> srcs = [
  //   "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
  //   "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
  //   "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  // ];
  bool isLoadingVideo = false;
  bool isPlaying = true;
  bool isHidePlaying = false;
  void intializeVideo({required int selectedIndex}) {
    log("message");
    isLoadingVideo = true;
    isPlaying = true;
    isHidePlaying = false;
    emit(LoadingVideoState());
    videoController = VideoPlayerController.network(
      videoList[selectedIndex].videoUrl!,
      videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true, allowBackgroundPlayback: true),
    )..initialize().whenComplete(() {
        isLoadingVideo = false;
        videoController.play();

        emit(InstializeVideoState());
      });
    videoController.addListener(() {
      if (videoController.value.position == videoController.value.duration) {
        isPlaying = true;
        isHidePlaying = true;
        emit(PauseVideoState());
      } else if (!videoController.value.isPlaying) {
        isPlaying = true;
        isHidePlaying = true;
        emit(VideoEndState());
      } else {
        isPlaying = true;
        isHidePlaying = false;

        emit(PalyVideoState());
      }
    });
  }

  play() async {
    await videoController.play();
  }

  pause() async {
    await videoController.pause();
    isPlaying = true;

    isHidePlaying = true;
    emit(PauseVideoState());
  }

  speed(speed) async {
    await videoController.setPlaybackSpeed(speed);

    emit(SpeedVideoState());
  }

  int videoVolume = 100;
  volume(volume) async {
    videoVolume = volume;
    await videoController.setVolume(volume / 100);

    emit(ChangeVolumeVideoState());
  }

  seek(seek) async {
    await videoController.seekTo(seek);
    emit(SeekVideoState());
  }

  @override
  Future<void> close() {
    videoController.dispose();

    return super.close();
  }
}
