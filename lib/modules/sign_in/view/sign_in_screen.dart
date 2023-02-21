import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/app_colors.dart';
import 'package:havefun/core/utils/function/validate.dart';
import 'package:havefun/core/utils/size_config.dart';
import 'package:havefun/core/widgets/app_button.dart';
import 'package:havefun/core/widgets/app_text_field.dart';
import 'package:havefun/core/widgets/head_shape.dart';
import 'package:havefun/core/widgets/loading_item.dart';
import 'package:havefun/modules/sign_in/controller/sign_in_cubit.dart';
import 'package:havefun/modules/sign_up/view/sign_up_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => SignInCubit(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Platform.isAndroid?Icons.arrow_back:Icons.arrow_back_ios)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body:
            SingleChildScrollView(child: BlocBuilder<SignInCubit, SignInState>(
          builder: (context, state) {
            final controller = SignInCubit.get(context);
            return Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getHeight(140),
                  ),
                  HeadShape(
                      height: getHeight(18),
                      width: getWidth(60),
                      headFontSize: getFont(35),
                      head: "Sign In"),
                  SizedBox(
                    height: getHeight(70),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(15), vertical: getHeight(15)),
                    child: TextFieldItem(
                        fristIcon: Icons.email_rounded,
                        lable: "Email Address",
                        onValidate: (validate) => Validate.notEmpty(validate),
                        controller: controller.emailController),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(15), vertical: getHeight(10)),
                    child: TextFieldItem(
                        fristIcon: Icons.lock,
                        isPassword: true,
                        lable: "Password",
                        isSecure: controller.isSecurePassword,
                        onTapViewPassword: () {
                          controller.switchViewPassword();
                        },
                        onValidate: (validate) => Validate.notEmpty(validate),
                        controller: controller.passwordController),
                  ),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Form(
                            key: controller.formKeyForget,
                            child: AlertDialog(
                              title: const Text("Forget Password"),
                              content: Padding(
                                padding: EdgeInsets.all(getWidth(10)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFieldItem(
                                        isAutoFalidate: true,
                                        lable: "Email Address",
                                        onValidate: (validate) =>
                                            Validate.validateEmail(validate),
                                        controller: controller
                                            .emailForgetPasswordController),
                                    SizedBox(
                                      height: getHeight(30),
                                    ),
                                    AppButton(
                                        onTap: () async {
                                          if (controller
                                              .formKeyForget.currentState!
                                              .validate()) {
                                            await controller.forgetPassword(
                                                context: context,
                                                email: controller
                                                    .emailForgetPasswordController
                                                    .text
                                                    .trim());
                                          }
                                        },
                                        head: "Confirm")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                          padding: EdgeInsets.only(right: getWidth(15)),
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forget Password",
                            style: TextStyle(
                                color: AppColors.secondryColor,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w700,
                                fontSize: getFont(20)),
                          ))),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getWidth(40),
                        right: getWidth(40),
                        top: getHeight(30),
                        bottom: getHeight(20)),
                    child: controller.isLoadingSignIn
                        ? const LoadingItem()
                        : AppButton(
                            onTap: () async {
                              if (controller.formKey.currentState!.validate()) {
                                await controller.signIn(context: context);
                              }
                            },
                            head: "Sign In"),
                  ),
                  Center(
                    child: Text.rich(TextSpan(children: [
                      const TextSpan(text: "Don't have an account! "),
                      WidgetSpan(
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen(),
                                    ));
                              },
                              child: Text(
                                "Sign Up ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: getFont(18),
                                    color: AppColors.secondryColor),
                              ))),
                    ])),
                  )
                ],
              ),
            );
          },
        )),
      ),
    );
  }
}
