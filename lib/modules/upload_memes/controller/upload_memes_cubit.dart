import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/function/app_toast.dart';
import 'package:havefun/core/utils/function/get_image_picker.dart';
import 'package:havefun/core/utils/function/uplaod_image_firebase.dart';

part 'upload_memes_state.dart';

class UploadMemesCubit extends Cubit<UploadMemesState> {
  UploadMemesCubit() : super(UploadMemesInitial());
  static UploadMemesCubit get(context) => BlocProvider.of(context);
  final descriptionController = TextEditingController();
  File? imageFile;
  Future<void> onGetImage() async {
    try {
      imageFile = await getImagePicker(isCamera: false);
      emit(SuccessGetImageState());
    } catch (e) {
      imageFile = null;
      debugPrint(e.toString());
      emit(FaildGetImageState());
      appToast(msg: "Something went wrong, Try again!");
    }
  }

  String? image;
  bool isLoadingUploadMemes = false;
  uploadMemes() async {
    isLoadingUploadMemes = true;
    emit(LoadingUploadMemesState());
    try {
      image = await uploadImageFirebase(imageFile: imageFile!, folder: "memes");
      await FirebaseFirestore.instance.collection("memes").add(
        {
          "memes_img": image ?? "",
          "description": descriptionController.text.trim().isEmpty
              ? ""
              : descriptionController.text.trim(),
          "added_at": DateTime.now()
        },
      ).then((value) async {
        FirebaseFirestore.instance
            .collection("memes")
            .doc(value.id)
            .update({"doc_id": value.id});
        descriptionController.clear();
        imageFile = null;
      });
      isLoadingUploadMemes = false;
      
        appToast(msg: "Memes Update Successfuly");
      emit(SuccessUploadMemesState());
    } catch (e) {
      isLoadingUploadMemes = false;
      emit(FaildUploadMemesState());
      debugPrint(e.toString());
      
      appToast(msg: "Something went wrong, try again!");
    }
  }
}
