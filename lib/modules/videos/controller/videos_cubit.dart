import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

part 'videos_state.dart';

class VideosCubit extends Cubit<VideosState> {
  VideosCubit() : super(VideosInitial());
  late VideoPlayerController videoController;
  static VideosCubit get(context) => BlocProvider.of(context);
  List<String> srcs = [
    "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];
  bool isLoadingVideo = false;
  bool isPlaying = true;
  bool isHidePlaying = false;
  void intializeVideo({required int selectedIndex}) {
    isLoadingVideo = true;
    isPlaying = true;
    isHidePlaying = false;
    emit(LoadingVideoState());
    videoController = VideoPlayerController.network(
      srcs[selectedIndex],
      videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true, allowBackgroundPlayback: true),
    )..initialize().whenComplete(() {
        isLoadingVideo = false;
        videoController.play();
        videoController.value.position;
        videoController.value.duration;

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

  volume(volume) async {
    await videoController.setVolume(volume / 100);
    emit(ChangeVolumeVideoState());
  }

  seek(seek) async {
    await videoController.seekTo(seek);
    emit(SeekVideoState());
  }
}
