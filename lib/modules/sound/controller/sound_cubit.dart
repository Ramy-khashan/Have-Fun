import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/modules/sound/model/music_model.dart';
import 'package:just_audio/just_audio.dart';

import '../model/page_manager.dart';

part 'sound_state.dart';

class SoundCubit extends Cubit<SoundState> {
  SoundCubit() : super(SoundInitial());
  static SoundCubit get(context) => BlocProvider.of(context);
  late int duration = 0;
  late int selectedSongIndex;
  late List<MusicModel> musicList = [
    MusicModel(
        musicUrl:
            "https://firebasestorage.googleapis.com/v0/b/upload-music-3cd4e.appspot.com/o/WhatsApp%20Audio%202022-12-14%20at%2011.51.59%20AM.mp3?alt=media&token=98ff7d83-3e32-4c58-aed8-12ea0af6ae76",
        musicName: "Song 1"),
    MusicModel(
        musicUrl:
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        musicName: "Song 2"),
    MusicModel(
        musicUrl:
            'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
        musicName: "Song 3"),
    MusicModel(musicUrl: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3', musicName: "Song 4"),
    MusicModel(musicUrl: 'https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3', musicName: "Song 5"),
    // MusicModel(musicUrl: 'https://example.com/track3.mp3', musicName: "Song 6"),
    // MusicModel(musicUrl: 'https://foo.com/bar.mp3', musicName: "Song 6")
  ];
  // List<String> url = [
  //   "https://firebasestorage.googleapis.com/v0/b/upload-music-3cd4e.appspot.com/o/WhatsApp%20Audio%202022-12-14%20at%2011.51.59%20AM.mp3?alt=media&token=98ff7d83-3e32-4c58-aed8-12ea0af6ae76",
  //   "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
  //   'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba-online-audio-converter.com_-1.wav'
  // ];
  late AudioPlayer audioPlayer;
  double volume = 100;
  void init(int intialSong) async {
    selectedSongIndex = intialSong;
    audioPlayer = AudioPlayer();

    await audioPlayer.setUrl(musicList[intialSong].musicUrl);
    audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
        emit(LoadingAudioState());
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
        emit(PausedAudioState());
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;

        emit(PlayingAudioState());
      } else {
        // completed
        audioPlayer.seek(Duration.zero);
        audioPlayer.pause();
      }
    });
    audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
    audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
    audioPlayer.play();
    test();
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  void play() async {
    await audioPlayer.play();
  }

  void pause() async {
    await audioPlayer.pause();
  }

  void stop() async {
    await audioPlayer.stop();
    init(selectedSongIndex);
  }

  void speed() async {
    await audioPlayer.setSpeed(2.0);
  }

  test() {
    Duration time = audioPlayer.duration!;
    duration = time.inSeconds;
    emit(GetDurationState());
  }

  void changeVolume() async {
    await audioPlayer.setVolume(volume / 100);
    emit(ChangeAudioVolumeState());
  }

  void dispose() {
    audioPlayer.dispose();
  }

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
}
