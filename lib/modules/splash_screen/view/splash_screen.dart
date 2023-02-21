import 'dart:async'; 

import 'package:flutter/material.dart'; 
import 'package:havefun/modules/navigator_bar_page/view/navigator_bar_page_screen.dart';

import '../../../core/utils/size_config.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 1900), () {
       Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                 const NavigatorBarPageScreen(),
          ),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 0, end: 1),
          builder: ((_, value, __) => Opacity(
                opacity: value,
                child: Center(
                  child: Text(
                    "Have Fun",
                    style: TextStyle(
                        fontFamily: "splash",
                        fontSize: getFont(60),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ))),
    );
  }
}
