 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../modules/splash_screen/view/splash_screen.dart';
import 'app_toast.dart';
import 'shared_prefrance_utils.dart';

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