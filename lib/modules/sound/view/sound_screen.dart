import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/app_colors.dart';
import 'package:havefun/core/utils/size_config.dart';
import 'package:havefun/modules/navigator_bar_page/view/navigator_bar_page_screen.dart';

import '../controller/sound_cubit.dart';
import '../model/page_manager.dart';

class SoundScreen extends StatelessWidget {
  final int intialIndex;
  const SoundScreen({Key? key, this.intialIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SoundCubit()..init(intialIndex),
      child: BlocBuilder<SoundCubit, SoundState>(
        builder: (context, state) {
          final controller = SoundCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                  onPressed: () {
                    controller.audioPlayer.stop();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavigatorBarPageScreen(),
                        ),
                        (route) => false);
                  },
                  icon: Icon(Platform.isAndroid
                      ? Icons.arrow_back
                      : Icons.arrow_back_ios_new)),
            ),
            body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      controller
                          .musicList[controller.selectedSongIndex].musicName,
                      style: TextStyle(
                        fontSize: getFont(30),
                        fontWeight: FontWeight.w700,
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
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black),
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
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black),
                          child: IconButton(
                              onPressed: () {
                                controller.stop();
                              },
                              icon: const Icon(Icons.stop)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: getWidth(10)),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black),
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
                        Container(
                          margin: EdgeInsets.only(right: getWidth(10)),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black),
                          child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  enableDrag: true,
                                  elevation: 20,
                                  builder: (context) {
                                    return Container(
                                      margin:
                                          EdgeInsets.only(top: getHeight(50)),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: getWidth(100),
                                            height: getHeight(9),
                                            decoration: const BoxDecoration(
                                                color: AppColors.secondryColor,
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(25),
                                                    bottomRight:
                                                        Radius.circular(25))),
                                          ),
                                          SizedBox(
                                            height: getHeight(10),
                                          ),
                                          Expanded(
                                            child: ListView.separated(
                                              padding:
                                                  EdgeInsets.all(getWidth(15)),
                                              itemBuilder: (context, index) =>
                                                  ListTile(
                                                title: Text(
                                                  controller.musicList[index]
                                                      .musicName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: getFont(22)),
                                                ),
                                                trailing: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                Colors.black),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          controller.pause();
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    SoundScreen(
                                                                        intialIndex:
                                                                            index),
                                                              ));
                                                        },
                                                        icon: const Icon(
                                                            Icons.play_arrow))),
                                              ),
                                              separatorBuilder:
                                                  (context, index) => SizedBox(
                                                height: getHeight(10),
                                              ),
                                              itemCount:
                                                  controller.musicList.length,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.menu)),
                        )
                      ],
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
