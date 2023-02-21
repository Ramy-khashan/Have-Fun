import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/widgets/loading_item.dart';
import 'package:havefun/modules/sound/view/sound_screen.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../core/widgets/empty.dart';
import '../controller/music_category_item_cubit.dart';

class MusicCaategoryItemScreen extends StatelessWidget {
  final String categoryType;
  const MusicCaategoryItemScreen({super.key, required this.categoryType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MusicCategoryItemCubit()..getMusicCaegoryItme(category: categoryType),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          title: Text(
            categoryType[0].toUpperCase() +
                categoryType.split(categoryType[0])[1],
            style: TextStyle(
              fontSize: getFont(40),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: BlocBuilder<MusicCategoryItemCubit, MusicCategoryItemState>(
          builder: (context, state) {
            final controller = MusicCategoryItemCubit.get(context);
            return controller.isLoadingcategory
                ? const LoadingItem()
                : controller.musicList.isEmpty
                    ? const EmptyShape()
                    : ListView.separated(
                        padding: EdgeInsets.only(top: getHeight(10)),
                        itemBuilder: (context, index) => Card(
                          elevation: 15,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(getWidth(
                                controller.musicList[index].audioName!.length >
                                        40
                                    ? 6
                                    : 11)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SoundScreen(
                                        musicModel:
                                            controller.musicList[index]),
                                  ));
                            },
                            leading: Icon(
                              Icons.music_note_outlined,
                              size: getWidth(50),
                              color: AppColors.secondryColor,
                            ),
                            title: Text(controller.musicList[index].audioName!
                                .split("(MP3")[0]),
                          ),
                        ),
                        separatorBuilder: (context, index) => Divider(
                          color: AppColors.primaryColor,
                          thickness: 1.5,
                          height: getHeight(20),
                        ),
                        itemCount: controller.musicList.length,
                      );
          },
        ),
      ),
    );
  }
}
