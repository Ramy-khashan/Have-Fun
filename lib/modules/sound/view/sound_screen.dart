import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/app_assets.dart';
import 'package:havefun/core/utils/app_colors.dart';
import 'package:havefun/core/utils/function/validate.dart';
import 'package:havefun/core/utils/size_config.dart';

import '../../../data/category_type.dart';
import '../../sound_category_item/model/model_music.dart';
import '../controller/sound_cubit.dart';
import '../model/page_manager.dart';

class SoundScreen extends StatelessWidget {
  final MusicModel musicModel;
  const SoundScreen({Key? key, required this.musicModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SoundCubit()..init(musicModel.audioUrl!),
      child: BlocBuilder<SoundCubit, SoundState>(
        builder: (context, state) {
          final controller = SoundCubit.get(context);
          return WillPopScope(
            onWillPop: () async {
              controller.audioPlayer.stop();

              controller.audioPlayer.dispose();
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () {
                    controller.audioPlayer.stop();

                    controller.audioPlayer.dispose();
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Platform.isAndroid
                        ? Icons.arrow_back
                        : Icons.arrow_back_ios,
                  ),
                ),
              ),
              body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: getHeight(40),
                      ),
                      Text(
                        musicModel.audioName!.split("(MP3")[0],
                        textAlign: Validate.upperCaseRegex.hasMatch(
                                musicModel.audioName!.split("(MP3")[0])
                            ? TextAlign.left
                            : TextAlign.right,
                        style: TextStyle(
                          fontSize: getFont(25),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        width: getWidth(400),
                        height: getHeight(300),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: musicModel.category ==
                                  CategoryType.category[0]
                              ? AppAssets.playing1Img
                              : musicModel.category == CategoryType.category[1]
                                  ? AppAssets.playing3Img
                                  : musicModel.category ==
                                          CategoryType.category[2]
                                      ? AppAssets.playing2Img
                                      : AppAssets.playing4Img,
                          width: getWidth(400),
                          height: getHeight(300),
                          fit: BoxFit.fill,
                        ),
                      ),
                      const Spacer(),
                      ValueListenableBuilder<ProgressBarState>(
                        valueListenable: controller.progressNotifier,
                        builder: (_, value, __) {
                          return ProgressBar(
                            progress: value.current,
                            buffered: value.buffered,
                            total: value.total,
                            baseBarColor: AppColors.secondryColor,
                            thumbColor: AppColors.primaryColor,
                            progressBarColor: AppColors.primaryColor,
                            onSeek: controller.seek,
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: getWidth(10)),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            child: ValueListenableBuilder<ButtonState>(
                              valueListenable: controller.buttonNotifier,
                              builder: (_, value, __) {
                                switch (value) {
                                  case ButtonState.loading:
                                    return Container(
                                      margin: const EdgeInsets.all(8.0),
                                      width: 32.0,
                                      height: 32.0,
                                      child: const CircularProgressIndicator(),
                                    );
                                  case ButtonState.paused:
                                    return IconButton(
                                      icon: const Icon(Icons.play_arrow),
                                      iconSize: getWidth(32),
                                      onPressed: controller.play,
                                    );
                                  case ButtonState.playing:
                                    return IconButton(
                                      icon: const Icon(Icons.pause),
                                      iconSize: getWidth(32),
                                      onPressed: controller.pause,
                                    );
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: getWidth(10)),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            child: IconButton(
                                onPressed: () {
                                  controller.stop();
                                },
                                icon: const Icon(Icons.stop)),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: getWidth(10)),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            child: controller.volume == 0
                                ? IconButton(
                                    onPressed: () {
                                      controller.volume = 100;
                                      controller.changeVolume();
                                    },
                                    icon: const Icon(Icons.volume_mute_rounded))
                                : IconButton(
                                    onPressed: () {
                                      controller.volume = 0;
                                      controller.changeVolume();
                                    },
                                    icon: const Icon(
                                      Icons.volume_up_rounded,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}
