import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../model/page_manager.dart';

part 'sound_state.dart';

class SoundCubit extends Cubit<SoundState> {
  SoundCubit() : super(SoundInitial());
  static SoundCubit get(context) => BlocProvider.of(context);
  late int duration = 0;
  late int selectedSongIndex;
  int selectedImage = 1;

  late AudioPlayer audioPlayer;
  double volume = 100;
  String? audioUrl;
  void init(String audio) async {
    audioPlayer = AudioPlayer();
    audioUrl = audio;
    await audioPlayer.setUrl(audio);

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
    init(audioUrl!);
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

  @override
  Future<void> close() {
    audioPlayer.stop();

    audioPlayer.dispose();

    return super.close();
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
