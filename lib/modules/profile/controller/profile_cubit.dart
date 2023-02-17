import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/shared_preferance_const.dart';
import 'package:havefun/modules/navigator_bar_page/view/navigator_bar_page_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/function/app_toast.dart';
import '../../../core/utils/function/shared_prefrance_utils.dart';
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
    // if (file != null) {
    //   image = await uploadImageFirebase();
    // }

    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(PreferenceUtils.getString(SharedPreferencesConst.docId))
          .update({
        "name": nameController.text.trim().isEmpty
            ? PreferenceUtils.getString(SharedPreferencesConst.name)
            : nameController.text.trim(),
        "image":
            // file != null
            //     ? image
            //     :
            PreferenceUtils.getString(SharedPreferencesConst.image)
      }).whenComplete(() async {
        await PreferenceUtils.setString(
            SharedPreferencesConst.name, nameController.text.trim());
        await PreferenceUtils.setString(
            SharedPreferencesConst.image,
            // file != null
            //     ? image
            //     :
            PreferenceUtils.getString(SharedPreferencesConst.image));
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

  // Future<String> uploadImageFirebase() async {
  //   // int ranNum = Random().nextInt(10000000);
  //   // String imageBasename = path.basename(file!.path) + ranNum.toString();

  //   // var ref =
  //   //     FirebaseStorage.instance.ref().child("personalImag/$imageBasename");
  //   // await ref.putFile(
  //   //   File(file!.path),
  //   // );
  //   // return await ref.getDownloadURL();
  // }

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
