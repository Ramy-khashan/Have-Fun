import 'package:flutter/material.dart'; 
import '../utils/app_colors.dart';
import '../utils/size_config.dart';

class HeadShape extends StatelessWidget {
  final double height;
  final double width;
  final String head;
  final double headFontSize;
  const HeadShape({Key? key, required this.height, required this.width, required this.head, required this.headFontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getWidth(width),
        vertical: getHeight(height),
      ),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Text(
        head,
        style: TextStyle(fontFamily: "title",fontSize: getFont(headFontSize), fontWeight: FontWeight.bold),
      ),
    );
  }
}
