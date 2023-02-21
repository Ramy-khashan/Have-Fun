import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/app_colors.dart';
import 'package:havefun/core/utils/function/app_toast.dart';
import 'package:havefun/core/utils/size_config.dart';
import 'package:havefun/core/widgets/app_button.dart';
import 'package:havefun/core/widgets/app_text_field.dart';
import 'package:havefun/core/widgets/text_title.dart';

import '../../../core/widgets/loading_item.dart';
import '../controller/upload_video_cubit.dart';

class UploadVideoScreen extends StatelessWidget {
  const UploadVideoScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploadVideoCubit(),
      child: BlocBuilder<UploadVideoCubit, UploadVideoState>(
        builder: (context, state) {
          final controller = UploadVideoCubit.get(context);
          return Padding(
            padding: EdgeInsets.all(getWidth(15)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextTitleItem(title: "Video description"),
                  TextFieldItem(
                    lable: "",
                    onValidate: (validate) {
                      return null;
                    },
                    lines: 3,
                    controller: TextEditingController(),
                  ),
                  Row(
                    children: [
                      const TextTitleItem(title: "Video"),
                      const Spacer(),
                      controller.chewieController != null &&
                              controller.chewieController!.videoPlayerController
                                  .value.isInitialized
                          ? IconButton(
                              onPressed: () async {
                                await controller.onGetVideo();
                              },
                              icon: const Icon(Icons.replay_outlined))
                          : const SizedBox()
                    ],
                  ),
                  Container(
                    height: getHeight(194),
                    width: double.infinity,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: controller.chewieController != null &&
                            controller.chewieController!.videoPlayerController
                                .value.isInitialized
                        ? Chewie(
                            controller: controller.chewieController!,
                          )
                        : GestureDetector(
                            onTap: () async {
                              await controller.onGetVideo();
                            },
                            child: SizedBox(
                              height: getHeight(194),
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.ondemand_video,
                                    color: AppColors.secondryColor,
                                    size: getWidth(60),
                                  ),
                                  SizedBox(
                                    height: getHeight(15),
                                  ),
                                  Text(
                                    "Pick up video",
                                    style: TextStyle(
                                        fontSize: getFont(25),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "head"),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                 SizedBox(height: getHeight(100),)  ,
                  controller.isLoadingUploadVideo
                      ? const LoadingItem()
                      :
                  AppButton(
                      onTap: () async {
                        if (controller.fileVideo != null) {
                         controller.uploadVideo();
                        } else {
                          appToast(
                              msg: "You must select video to complete Process");
                        }
                      },
                      head: "Upload Video")
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
