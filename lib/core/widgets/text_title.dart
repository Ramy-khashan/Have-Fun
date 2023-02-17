import 'package:flutter/material.dart';
import 'package:havefun/core/utils/size_config.dart';

class TextTitleItem extends StatelessWidget {
  final String title;
  const TextTitleItem({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: getHeight(14),
        bottom: getHeight(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: getFont(25),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
