import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:havefun/core/utils/function/commet_model_sheet.dart';
import 'package:havefun/core/utils/function/validate.dart';
import 'package:havefun/core/widgets/loading_item.dart';
import 'package:havefun/modules/memes/model/memes_model.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_button.dart';

class MemesShapeItem extends StatelessWidget {
  final MemesModel memesModel;
  const MemesShapeItem({Key? key, required this.memesModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
      clipBehavior: Clip.antiAliasWithSaveLayer,
     decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12)
     ),
      child: Column(
        children: [
          memesModel.description!.isEmpty
              ? const SizedBox.shrink()
              : Align(
                  alignment: Validate.upperCaseRegex
                              .hasMatch(memesModel.description!) ||
                          Validate.lowerCaseRegex
                              .hasMatch(memesModel.description!)
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      memesModel.description!,
                      style: TextStyle(
                        fontSize: getFont(22),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
          CachedNetworkImage(
            height: getHeight(250),
            width: double.infinity,
              fit: BoxFit.fill,
              imageUrl: memesModel.memesImg!,
              progressIndicatorBuilder: (context, url, progress) =>
                  SizedBox(height: getHeight(250), child: const LoadingItem()),
              errorWidget: (context, url, error) =>
                 const Center(child:   Text("Something went wrong, Check your network!"))),
          const Divider(
            color: AppColors.secondryColor,
          ),
          AppButton(
            onTap: () {
              showSheet(context: context, memesDocId: memesModel.docId!);
            },
            height: getHeight(45),
            head: "Comment",
            radius: 5,
          )
        ],
      ),
    );
  }
}
