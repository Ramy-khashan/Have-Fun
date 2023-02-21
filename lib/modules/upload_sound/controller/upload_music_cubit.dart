import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/function/app_toast.dart';
import 'package:havefun/core/utils/function/shared_prefrance_utils.dart';
import 'package:havefun/core/utils/shared_preferance_const.dart';
import 'package:havefun/data/category_type.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;

import '../../sound/model/page_manager.dart';

part 'upload_music_state.dart';

class UploadMusicCubit extends Cubit<UploadMusicState> {
  UploadMusicCubit() : super(UploadMusicInitial());
  static UploadMusicCubit get(context) => BlocProvider.of(context);
  final formKey = GlobalKey<FormState>();
  final musicNameController = TextEditingController();
  late final FileType pickingType = FileType.audio;
  late String categoryType = CategoryType.category[0];
  onChangeCategory(String val) {
    categoryType = val;
    emit(ChangeCategoryState());
  }

  FilePickerResult? file;
  Future getMusic() async {
    file = await FilePicker.platform.pickFiles(
      type: pickingType,
    );
    if (file != null) {
      musicNameController.text = file!.files.first.name.split(".m")[0].trim();
      init(file);

      emit(PickMusicState());
    }
  }

  late AudioPlayer audioPlayer;
  double volume = 100;
  bool isEnter = false;
  void init(musicFile) async {
    isEnter = true;
    audioPlayer = AudioPlayer();
    try {
      await audioPlayer.setFilePath(musicFile!.paths.first);
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
    } catch (e) {
      debugPrint(e.toString());
    }
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
  }

  @override
  Future<void> close() {
    try {
      if (isEnter) {
        audioPlayer.dispose();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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
  uploadAndGetUrlMusic() async {
    int ranNum = Random().nextInt(10000000);
    String songBasename =
        path.basename(file!.paths[0] as String) + ranNum.toString();

    var ref = FirebaseStorage.instance.ref().child("songs/$songBasename");
    final item = file!.paths[0];
    await ref.putFile(
      File(item!),
    );
    return await ref.getDownloadURL();
  }

  bool isUploadingAudio = false;

  uploadMusic() async {
    isUploadingAudio = true;
    emit(LoadingMusicUploadState());
    try {
      String url = await uploadAndGetUrlMusic();
      if (url != null || url.isNotEmpty) {
        await FirebaseFirestore.instance.collection("audio").add({
          "audio_url": url,
          "audio_name": musicNameController.text.trim(),
          "audio_added_at": DateTime.now(),
          "category": categoryType,
          "user_doc_id":
              PreferenceUtils.getString(SharedPreferencesConst.docId),
          "user_auth_id": PreferenceUtils.getString(SharedPreferencesConst.uid),
        }).then((value) async {
          FirebaseFirestore.instance
              .collection("audio")
              .doc(value.id)
              .update({"doc_id": value.id});
        });
        isUploadingAudio = false;
        file = null;
        musicNameController.clear;
        emit(SuccessMusicUploadState());
        appToast(msg: "Audio Uploaded Successfully");
      } else {
        isUploadingAudio = false;
        emit(FaildMusicUploadState());

        appToast(msg: "Something went wrong, Please try again!");
      }
    } catch (e) {
      isUploadingAudio = false;

      emit(FaildMusicUploadState());
      appToast(msg: "Something went wrong, Please try again!");
      debugPrint(e.toString());
    }
  }
}
