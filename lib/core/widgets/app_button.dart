import 'package:flutter/material.dart';
import 'package:havefun/core/utils/app_colors.dart';
import 'package:havefun/core/utils/size_config.dart';

class AppButton extends StatelessWidget {
  final Function() onTap;
  final String head;
  final double width;
  final double height;
  final double fontSize;
  final double radius;
  final Color color;
  const AppButton(
      {Key? key,
      required this.onTap,
      required this.head,
      this.width = double.infinity,
      this.height = 50,
      this.fontSize = 25,
      this.radius = 30,   this.color=AppColors.primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, getHeight(height)),
        primary:color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      onPressed: onTap,
      child: Text(head,
          style: TextStyle(
              color: Colors.white,
              fontFamily: "title",
              fontSize: getFont(fontSize),
              fontWeight: FontWeight.w500)),
    );
  }
}
