import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/function/shared_prefrance_utils.dart';
import 'package:havefun/modules/navigator_bar_page/view/navigator_bar_page_screen.dart';

import '../../../core/utils/function/app_toast.dart';
import '../../../core/utils/shared_preferance_const.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());
  static SignInCubit get(context) => BlocProvider.of(context);
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSecurePassword = true;
  switchViewPassword() {
    isSecurePassword = !isSecurePassword;
    emit(ChangeViewPasswordState());
  }

  login() async {}
  bool isLoadingSignIn = false;
  signIn({context}) async {
    isLoadingSignIn = true;
    emit(LoadingSignInState());

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) async {
        await FirebaseFirestore.instance
            .collection("user")
            .where("auth_id", isEqualTo: value.user!.uid)
            .get()
            .then((userData) async {
          await PreferenceUtils.setString(
              SharedPreferencesConst.name, userData.docs[0].get("name"));
          await PreferenceUtils.setString(
              SharedPreferencesConst.email, userData.docs[0].get("email"));
          await PreferenceUtils.setString(
              SharedPreferencesConst.image, userData.docs[0].get("image"));
          await PreferenceUtils.setString(
              SharedPreferencesConst.uid, userData.docs[0].get("auth_id"));
          await PreferenceUtils.setString(
              SharedPreferencesConst.uid, userData.docs[0].get("doc_id"));
        });
      });
      isLoadingSignIn = false;
      emit(SuccessSignInState());

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const NavigatorBarPageScreen(),
          ),
          (route) => false);
    } catch (e) {
      if (e is FirebaseException) {
        appToast(msg: e.message!);
      } else {
        appToast(msg: "Faild to sign In and try again!");
      }
      isLoadingSignIn = false;
      emit(FaildSignInState());
    }
  }
}
