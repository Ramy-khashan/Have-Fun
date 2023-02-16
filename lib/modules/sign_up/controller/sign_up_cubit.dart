import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/function/app_toast.dart';
import 'package:havefun/modules/sign_in/view/sign_in_screen.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());
  static SignUpCubit get(context) => BlocProvider.of(context);
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isSecurePassword = true;
  switchViewPassword() {
    isSecurePassword = !isSecurePassword;
    emit(ChangeViewPasswordState());
  }

  bool isLoadingSignUp = false;
  signUp({context}) async {
    isLoadingSignUp = true;
    emit(LoadingSignUpState());

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) async {
        await FirebaseFirestore.instance.collection("user").add({
          "name": fullNameController.text.trim(),
          "email": emailController.text.trim(),
          "image":
              "https://firebasestorage.googleapis.com/v0/b/have-fun-a5c87.appspot.com/o/userImg.png?alt=media&token=4f962df4-7c2d-4dd2-8950-f64e1ed9863d",
          "auth_id": value.user!.uid,
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection("user")
              .doc(value.id)
              .update({"doc_id": value.id});
        });
      });
      isLoadingSignUp = false;
      emit(SuccessSignUpState());
      appToast(msg: "Create Account Successfully, Sign In");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
          (route) => false);
    } catch (e) {
      if (e is FirebaseException) {
        appToast(msg: e.message!);
      } else {
        appToast(msg: "Faild to sign up and try again!");
      }
      isLoadingSignUp = false;
      emit(FaildSignUpState());
    }
  }
}
