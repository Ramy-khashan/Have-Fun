import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/shared_preferance_const.dart';
import 'package:havefun/modules/navigator_bar_page/view/navigator_bar_page_screen.dart';

import '../../../core/utils/function/app_toast.dart';
import '../../../core/utils/function/get_image_picker.dart';
import '../../../core/utils/function/shared_prefrance_utils.dart';
import '../../../core/utils/function/uplaod_image_firebase.dart';
import '../../splash_screen/view/splash_screen.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial()) {
    debugPrint(
        PreferenceUtils.getString(SharedPreferencesConst.docId).toString());
  }
  static ProfileCubit get(context) => BlocProvider.of(context);
  late TextEditingController nameController = TextEditingController();

  late bool isEditName = false;
  changeName() {
    isEditName = !isEditName;
    if (isEditName) {
      nameController.text =
          PreferenceUtils.getString(SharedPreferencesConst.name);
    } else {
      nameController.clear();
    }
    Future.delayed(const Duration(milliseconds: 500));
    emit(ToChangeNameState());
  }

  bool isLoadingUplading = false;
  changeImageOrName(context) async {
    isLoadingUplading = true;
    emit(LoadingUpdateState());
    if (imageFile != null) {
      image = await uploadImageFirebase(imageFile: imageFile!);
    }

    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(PreferenceUtils.getString(SharedPreferencesConst.docId))
          .update({
        "name": nameController.text.trim().isEmpty
            ? PreferenceUtils.getString(SharedPreferencesConst.name)
            : nameController.text.trim(),
        "image": imageFile != null
            ? image
            : PreferenceUtils.getString(SharedPreferencesConst.image)
      }).whenComplete(() async {
        await PreferenceUtils.setString(
          SharedPreferencesConst.name,
          nameController.text.trim().isEmpty
              ? PreferenceUtils.getString(SharedPreferencesConst.name)
              : nameController.text.trim(),
        );
        await PreferenceUtils.setString(
            SharedPreferencesConst.image,
            imageFile != null
                ? image
                : PreferenceUtils.getString(SharedPreferencesConst.image));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const NavigatorBarPageScreen(selectedPage: 2),
            ));

        isLoadingUplading = false;
        emit(LoadingUpdateState());
        appToast(msg: "Updated Successfuly");
      }).onError<FirebaseException>((error, stackTrace) {
        isLoadingUplading = false;
        emit(LoadingUpdateState());
        appToast(msg: error.message!);
      });
    } catch (e) {
      isLoadingUplading = false;
      emit(LoadingUpdateState());
      appToast(msg: "Something went wrong with upload, Please try again!");
    }
  }

  late String image;
  File? imageFile;

  Future<void> onGetImage({required bool isCamera}) async {
    try {
      imageFile = await getImagePicker(isCamera: isCamera);
      emit(SuccessGetImageState());
    } catch (e) {
      imageFile = null;
      debugPrint(e.toString());
      emit(FaildGetImageState());
      appToast(msg: "Something went wrong, Try again!");
    }
  }

  resetPassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(
            email: PreferenceUtils.getString(SharedPreferencesConst.email))
        .then((value) {
      appToast(msg: "Check your email, To update password");
    });
  }
}
