import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class TextFieldItem extends StatelessWidget {
  final String lable;
  final int lines;
  final Function(dynamic validate) onValidate;
  final Function()? onTapViewPassword;
  final TextEditingController controller;
  final bool isSecure;
  final bool isPassword;
  final bool isAutoFalidate;
  final IconData? fristIcon;

  const TextFieldItem(
      {Key? key,
      required this.lable,
      this.lines = 1,
      required this.onValidate,
      required this.controller,
      this.isSecure = false,
      this.isPassword = false,
      this.onTapViewPassword,
      this.fristIcon,
      this.isAutoFalidate = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: isAutoFalidate
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      obscureText: isPassword ? isSecure : false,
      cursorColor: AppColors.secondryColor,
      controller: controller,
      validator: (value) => onValidate(value),
      maxLines: lines,
      decoration: InputDecoration(
        labelText: lable,
        labelStyle: const TextStyle(color: AppColors.secondryColor),
        prefixIcon: fristIcon == null
            ? null
            : Icon(
                fristIcon,
                color: AppColors.secondryColor,
              ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: onTapViewPassword,
                icon: Icon(
                  isSecure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.secondryColor,
                ))
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
