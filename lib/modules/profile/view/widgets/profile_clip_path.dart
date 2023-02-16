import 'package:flutter/material.dart';

import '../../../../core/utils/size_config.dart';

class ProfileClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
      //  SizeConfig().init(context);

    var path = Path();
    double h = getHeight(100);
    path.moveTo(getWidth(100), h);
    path.quadraticBezierTo(0, h, 0, h + getHeight(90));

    path.lineTo(0, 0);
    path.lineTo(size.width, 0);

    path.lineTo(size.width, h - getHeight(110));
    path.quadraticBezierTo(size.width, h, getWidth(size.width - 100), h);

    // double height = size.height;
    // double width = size.width;

    // var path = Path();
    // path.lineTo(0, height);
    // path.quadraticBezierTo(width / 2, height, width, height);
    // path.lineTo(width, 0);
    // path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
