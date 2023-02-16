import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:havefun/core/utils/app_colors.dart';

import '../utils/size_config.dart';

class LoadingItem extends StatelessWidget {
  const LoadingItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      
      child: Center(
        child: SizedBox(
            width: getWidth(30),
            height: getHeight(30),
            child: Platform.isAndroid?const CircularProgressIndicator(color: AppColors.secondryColor,):const CircularProgressIndicator.adaptive()),
      ),
    );
  }
}
