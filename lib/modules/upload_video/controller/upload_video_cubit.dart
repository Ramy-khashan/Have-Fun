import 'dart:developer';
import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:havefun/core/utils/function/shared_prefrance_utils.dart';
// import 'package:havefun/core/utils/shared_preferance_const.dart';
// import 'package:path/path.dart' as path;

// import 'dart:io';
// import 'dart:math';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../core/utils/function/app_toast.dart';

part 'upload_video_state.dart';

class UploadVideoCubit extends Cubit<UploadVideoState> {
  UploadVideoCubit() : super(UploadVideoInitial());
  static UploadVideoCubit get(context) => BlocProvider.of(context);

  @override
  Future<void> close() {
    try {
      videoPlayerController1.dispose();
      chewieController?.dispose();
    } catch (e) {
      log(e.toString());
    }
    return super.close();
  }

  final descriptionVideo = TextEditingController();

  late XFile xFileVideo;
  File? fileVideo;
  // bool isLoadingGetVideoAndShow = false;
  onGetVideo() async {
    try {
      xFileVideo =
          (await ImagePicker().pickVideo(source: ImageSource.gallery))!;
      if (xFileVideo != null) {
        fileVideo = File(xFileVideo.path);
        await initializePlayer();
      } else {
        appToast(msg: "Something went wrong, try again!");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  late VideoPlayerController videoPlayerController1;
  ChewieController? chewieController;
  int? bufferDelay;
  Future<void> initializePlayer() async {
    try {
      videoPlayerController1 = VideoPlayerController.file(fileVideo!);

      await Future.wait([
        videoPlayerController1.initialize(),
      ]);
      createChewieController();

      emit(InitializeVideoState());
    } catch (e) {
      appToast(msg: "Something went wrong, try again!");
    }
  }

  createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController1,
      autoPlay: true,
      allowFullScreen: true,
      allowMuting: true,
      zoomAndPan: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      hideControlsTimer: const Duration(seconds: 3),
    );
  }

  // uploadAndGetUrlVideo() async {
  //   int ranNum = Random().nextInt(10000000);
  //   String videoBasename = path.basename(fileVideo!.path) + ranNum.toString();

  //   var ref =
  //       FirebaseStorage.instance.ref().child("videos/$videoBasename");
  //   await ref.putFile(
  //     File(fileVideo!.path),
  //   );
  //   return await ref.getDownloadURL();
  // }

  // bool isLoadingUploadVideo = false;
  // uploadVideo() async {
  //   isLoadingUploadVideo = true;
  //   emit(LoadingUploadVideoState());
  //   try {
  //     String videoUrl = await uploadAndGetUrlVideo();
  //     await FirebaseFirestore.instance.collection("video").add({
  //       "description": descriptionVideo.text.trim().isEmpty
  //           ? ""
  //           : descriptionVideo.text.trim(),
  //       "added_date": DateTime.now(),
  //       "video_url": videoUrl,
  //       "user_id": PreferenceUtils.getString(SharedPreferencesConst.docId)
  //     }).then((value) async {
  //       await FirebaseFirestore.instance
  //           .collection("video")
  //           .doc(value.id)
  //           .update({"doc_id": value.id});
  //       fileVideo = null;
  //       videoPlayerController1.dispose();
  //       chewieController?.dispose();

  //       isLoadingUploadVideo = false;
  //       emit(SuccessUploadVideoState());
  //       appToast(msg: "Video Update Successfuly");
  //     }).onError((error, stackTrace) {
  //       isLoadingUploadVideo = false;
  //       emit(FaildUploadVideoState());
  //       appToast(msg: "Something went wrong, try again!");
  //     });
  //   } catch (e) {
  //     isLoadingUploadVideo = false;
  //     emit(FaildUploadVideoState());
  //     appToast(msg: "Something went wrong, try again!");
  //   }
  // }

}
