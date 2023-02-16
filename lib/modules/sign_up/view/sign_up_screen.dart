import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/function/validate.dart';
import 'package:havefun/core/utils/size_config.dart';
import 'package:havefun/core/widgets/loading_item.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/head_shape.dart';
import '../controller/sign_up_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: Scaffold(
        body:
            SingleChildScrollView(child: BlocBuilder<SignUpCubit, SignUpState>(
          builder: (context, state) {
            final controller = SignUpCubit.get(context);
            return Form(
              key:controller.formKey ,

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
                      head: "Sign Up"),
                  SizedBox(
                    height: getHeight(70),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(15), vertical: getHeight(15)),
                    child: TextFieldItem(
                        fristIcon: Icons.person,
                        lable: "Full Name",
                        onValidate: (validate) => Validate.validateName(validate),
                        controller: controller.fullNameController),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(15), vertical: getHeight(15)),
                    child: TextFieldItem(
                        fristIcon: Icons.email_rounded,
                        lable: "Email Address",
                        onValidate: (validate) =>
                            Validate.validateEmail(validate),
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
                        onValidate: (validate) =>
                            Validate.validatePassword(validate),
                        controller: controller.passwordController),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getWidth(40),
                        right: getWidth(40),
                        top: getHeight(30),
                        bottom: getHeight(20)),
                    child: controller.isLoadingSignUp
                        ? const LoadingItem()
                        : AppButton(
                            onTap: () async {
                              if(controller.formKey.currentState!.validate()){
                              await controller.signUp(context: context);}
                            },
                            head: "Sign Up"),
                  ),
                  Center(
                    child: Text.rich(TextSpan(children: [
                      const TextSpan(text: "have an account already! "),
                      WidgetSpan(
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Sign In ",
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
