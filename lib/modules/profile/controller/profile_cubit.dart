import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/shared_preferance_const.dart';
import 'package:havefun/modules/navigator_bar_page/view/navigator_bar_page_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/function/app_toast.dart';
import '../../../core/utils/function/shared_prefrance_utils.dart';
import '../../splash_screen/view/splash_screen.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);
  late TextEditingController nameController = TextEditingController();
  late bool isEditName = false;
  changeName() {
    isEditName = !isEditName;
    if (isEditName) {
      nameController.text = "RamyKhashan";
    } else {
      nameController.clear();
    }
    Future.delayed(const Duration(milliseconds: 500));
    emit(ToChangeNameState());
  }

  changeImageOrName(context) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(PreferenceUtils.getString(SharedPreferencesConst.docId))
        .update({
      "name": nameController.text.trim().isEmpty
          ? PreferenceUtils.getString(SharedPreferencesConst.name)
          : nameController.text.trim(),
      "image": file != null
          ? image
          : PreferenceUtils.getString(SharedPreferencesConst.image)
    }).whenComplete(() async {
      await PreferenceUtils.setString(
          SharedPreferencesConst.name, nameController.text.trim());
      await PreferenceUtils.setString(SharedPreferencesConst.image, image);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>NavigatorBarPageScreen() ,));
    }).onError<FirebaseException>((error, stackTrace) {});
  }

  logOut(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await PreferenceUtils.clearStorage();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ),
          (route) => false);
    } catch (e) {
      if (e is FirebaseException) {
        appToast(msg: e.message!);
      } else {
        appToast(msg: "Something went wrong, Please try again!");
      }
    }
  }

  late XFile xFile;
  late String image;
  File? file;
  getImage({required bool isCamera}) async {
    try {
      xFile = (await ImagePicker().pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery))!;
      if (xFile.path.isNotEmpty) {
        file = File(xFile.path);
        emit(SuccessGetImageState());
      } else {
        appToast(msg: "Something went wrong, Try again!");
        emit(FaildGetImageState());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(FaildGetImageState());
    }
  }
}
