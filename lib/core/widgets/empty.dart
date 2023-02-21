import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:havefun/core/utils/app_assets.dart';
import 'package:havefun/core/utils/app_colors.dart';
import 'package:havefun/core/utils/size_config.dart';

class EmptyShape extends StatelessWidget {
  const EmptyShape({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppAssets.emptyImg,
          height: getHeight(300),
            color: Colors.white,
          ),
          Text(
            "Empty",
            style: TextStyle(
                fontSize: getFont(60),
                fontFamily: "head",
                fontWeight: FontWeight.w700,
                color: Colors.white),
          )
        ],
      ),
    );
  }
}
