import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/loading_item.dart';
import '../../../core/widgets/text_title.dart';
import '../controller/upload_memes_cubit.dart';

class UploadMemesScreen extends StatelessWidget {
  const UploadMemesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => UploadMemesCubit(),
      child: BlocBuilder<UploadMemesCubit, UploadMemesState>(
        builder: (context, state) {
          final controller = UploadMemesCubit.get(context);
          return Padding(
            padding: EdgeInsets.all(getWidth(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextTitleItem(title: "Memes description"),
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
                    const TextTitleItem(title: "Image"),
                    const Spacer(),
                    controller.imageFile != null
                        ? IconButton(
                            onPressed: () async {
                              await controller.onGetImage();
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
                  child: controller.imageFile != null
                      ? Image.file(
                          controller.imageFile!,
                          fit: BoxFit.fill,
                        )
                      : GestureDetector(
                          onTap: () async {
                            await controller.onGetImage();
                          },
                          child: SizedBox(
                            height: getHeight(194),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  color: AppColors.secondryColor,
                                  size: getWidth(60),
                                ),
                                SizedBox(
                                  height: getHeight(15),
                                ),
                                Text(
                                  "Pick up Image",
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
                const Spacer(),
                controller.isLoadingUploadMemes
                    ? const LoadingItem()
                    : AppButton(
                        onTap: () async {
                          controller.uploadMemes();
                        },
                        head: "Upload Memes")
              ],
            ),
          );
        },
      ),
    ));
  }
}
