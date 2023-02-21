import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/function/app_toast.dart';
import 'package:havefun/core/utils/function/validate.dart';
import 'package:havefun/core/widgets/app_button.dart';
import 'package:havefun/core/widgets/loading_item.dart';
import 'package:havefun/data/category_type.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/text_title.dart';
import '../../sound/model/page_manager.dart';
import '../controller/upload_music_cubit.dart';

class UploadMusicPart extends StatelessWidget {
  const UploadMusicPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploadMusicCubit(),
      child: Scaffold(body: BlocBuilder<UploadMusicCubit, UploadMusicState>(
        builder: (context, state) {
          final controller = UploadMusicCubit.get(context);
          return Padding(
            padding: EdgeInsets.all(getWidth(15)),
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextTitleItem(title: "Music Name"),
                    TextFieldItem(
                      lable: "",
                      onValidate: (validate) => Validate.notEmpty(validate),
                      lines: 1,
                      controller: controller.musicNameController,
                    ),
                    const TextTitleItem(title: "Music Category"),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: getWidth(10)),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButton(
                          elevation: 5,
                          dropdownColor: Colors.black,
                          underline: SizedBox(),
                          borderRadius: BorderRadius.circular(15),
                          isExpanded: true,
                          value: controller.categoryType,
                          items: CategoryType.category
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value[0].toUpperCase() +
                                  value.split(value[0])[1]),
                            );
                          }).toList(),
                          onChanged: (val) {
                            controller.onChangeCategory(val!);
                          }),
                    ),
                    Row(
                      children: [
                        const TextTitleItem(title: "Music"),
                        const Spacer(),
                        controller.file != null
                            ? IconButton(
                                onPressed: () async {
                                  await controller.getMusic();
                                },
                                icon: const Icon(Icons.replay_outlined))
                            : const SizedBox()
                      ],
                    ),
                    controller.file == null
                        ? Center(
                            child: GestureDetector(
                              onTap: () async {
                                await controller.getMusic();
                              },
                              child: Container(
                                width: getWidth(150),
                                height: getWidth(150),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.secondryColor,
                                        width: 1.5),
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryColor),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.music_note_rounded,
                                      size: getWidth(40),
                                    ),
                                    SizedBox(
                                      height: getHeight(15),
                                    ),
                                    Text(
                                      "Pick Up Music",
                                      style: TextStyle(
                                          fontSize: getFont(24),
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: [
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: getWidth(10)),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black),
                                    child: ValueListenableBuilder<ButtonState>(
                                      valueListenable:
                                          controller.buttonNotifier,
                                      builder: (_, value, __) {
                                        switch (value) {
                                          case ButtonState.loading:
                                            return Container(
                                              margin: const EdgeInsets.all(8.0),
                                              width: 32.0,
                                              height: 32.0,
                                              child:
                                                  const CircularProgressIndicator(),
                                            );
                                          case ButtonState.paused:
                                            return IconButton(
                                              icon:
                                                  const Icon(Icons.play_arrow),
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
                                    margin:
                                        EdgeInsets.only(right: getWidth(10)),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black),
                                    child: IconButton(
                                        onPressed: () {
                                          controller.stop();
                                        },
                                        icon: const Icon(Icons.stop)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    SizedBox(
                      height: getHeight(80),
                    ),
                    controller.isUploadingAudio
                        ? const LoadingItem()
                        : AppButton(
                            onTap: () async {
                              if (controller.formKey.currentState!.validate()) {
                                if (controller.file != null) {
                                  controller.uploadMusic();
                                } else {
                                  appToast(
                                      msg:
                                          "You must select song to complete Process");
                                }
                              }
                            },
                            head: "Upload Audio")
                  ],
                ),
              ),
            ),
          );
        },
      )),
    );
  }
}
