import 'package:flutter/material.dart';
import 'package:havefun/core/widgets/app_button.dart';
import 'package:havefun/modules/sign_in/view/sign_in_screen.dart';
import 'package:havefun/modules/sign_up/view/sign_up_screen.dart';

import '../app_colors.dart';
import '../size_config.dart';

needLogin({required BuildContext context}) => showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      elevation: 0,
      builder: (context) => Container(
        margin: EdgeInsets.only(top: getHeight(50)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: getWidth(100),
              height: getHeight(9),
              decoration: const BoxDecoration(
                  color: AppColors.secondryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
            ),
            SizedBox(
              height: getHeight(20),
            ),
            Padding(
              padding: EdgeInsets.all(getWidth(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      head: "Go to sign in"),
                  SizedBox(
                    height: getHeight(getHeight(15)),
                  ),
                  AppButton(
                      onTap: () {
                           Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
       
                      },
                      head: "Go to sign up"),
                  SizedBox(
                    height: getHeight(20),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
