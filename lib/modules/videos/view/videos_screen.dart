import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/app_colors.dart';
import 'package:havefun/core/utils/size_config.dart';
import 'package:havefun/core/widgets/empty.dart';
import 'package:video_player/video_player.dart';
import '../../../core/widgets/loading_item.dart';
import '../controller/videos_cubit.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideosCubit()..getVideos(),
      child: BlocBuilder<VideosCubit, VideosState>(
        builder: (context, state) {
          final controller = VideosCubit.get(context);
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              actions: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: IconButton(
                      onPressed: () {
                        controller.videoVolume == 100
                            ? controller.volume(0)
                            : controller.volume(100);
                      },
                      icon: Icon(controller.videoVolume == 100
                          ? Icons.volume_up
                          : Icons.volume_off,color: Colors.white,)),
                )
              ],
            ),
            body: controller.isLoadingGetVideo
                ? const LoadingItem()
                : controller.videoList.isEmpty
                    ? const EmptyShape()
                    : Center(
                        child: PageView.builder(
                        allowImplicitScrolling: false,
                        dragStartBehavior: DragStartBehavior.down,
                        padEnds: false,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (value) {
                          controller.pause();
                          controller.intializeVideo(selectedIndex: value);
                        },
                        itemBuilder: (context, index) => !controller
                                .videoController.value.isInitialized
                            ? const LoadingItem()
                            : GestureDetector(
                                onTap: () {
                                  if (controller
                                      .videoController.value.isPlaying) {
                                    controller.pause();
                                  } else {
                                    controller.play();
                                  }
                                },
                                child: Stack(
                                  children: [
                                    VideoPlayer(controller.videoController),
                                    Positioned(
                                      bottom: 0,
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: !controller.isPlaying
                                          ? AnimatedOpacity(
                                              duration: const Duration(
                                                  milliseconds: 100),
                                              opacity:
                                                  controller.isPlaying ? 1 : 0,
                                              child: const Center(
                                                child: CircleAvatar(
                                                    child: Icon(Icons.pause)),
                                              ),
                                            )
                                          : !controller.isHidePlaying
                                              ? const SizedBox()
                                              : const Center(
                                                  child: CircleAvatar(
                                                      child: Icon(
                                                          Icons.play_arrow)),
                                                ),
                                    ),
                                    Positioned(
                                        bottom: 25,
                                        child: Padding(
                                          padding: EdgeInsets.all(getWidth(8)),
                                          child: Text(
                                            controller
                                                .videoList[index].description!,
                                            style: TextStyle(
                                                fontSize: getFont(22),
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                        itemCount: controller.videoList.length,
                      )

                        // ProgressBar(
                        //   progress: Duration(seconds: 10),
                        //   total: Duration(seconds: 20),
                        //   onSeek: seek,
                        // ),

                        ),
          );
        },
      ),
    );
  }
}
