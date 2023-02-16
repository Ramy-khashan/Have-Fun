import 'package:flutter/material.dart';
import 'package:havefun/core/utils/function/commet_model_sheet.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_button.dart';

class MemesShapeItem extends StatelessWidget {
  const MemesShapeItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 15,
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            child: Image.asset(
              AppAssets.splashImg,
              width: double.infinity,
              fit: BoxFit.fill,
              height: getHeight(250),
            ),
          ),
          const Divider(
            color: AppColors.secondryColor,
          ),
          Row(
            children: [
              Expanded(
                  child: AppButton(
                onTap: () {},
                height: getHeight(45),
                head: "Like",
                radius: 5,
              )),
              Expanded(
                  child: AppButton(
                onTap: () {
                  showSheet(context: context);
                },
                height: getHeight(45),
                head: "Comment",
                radius: 5,
              )),
            ],
          ),
        ],
      ),
    );
  }
}
