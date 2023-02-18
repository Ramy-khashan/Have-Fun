import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/app_colors.dart';
import 'package:havefun/core/utils/function/shared_prefrance_utils.dart';
import 'package:havefun/core/utils/shared_preferance_const.dart';
import 'package:havefun/core/utils/size_config.dart';
import 'package:havefun/core/widgets/app_button.dart';
import 'package:havefun/core/widgets/custom_image_network.dart';
import 'package:havefun/core/widgets/loading_item.dart';
import 'package:havefun/modules/profile/controller/profile_cubit.dart';
import 'package:havefun/modules/profile/view/widgets/show_and_edit_name.dart';

import 'widgets/profile_clip_path.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.primaryColor,
            title: Text(
              "Profile",
              style: TextStyle(
                fontSize: getFont(40),
                fontWeight: FontWeight.w500,
              ),
            )),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final controller = ProfileCubit.get(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: ProfileClip(),
                      child: Container(
                        height: getHeight(170),
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomRight,
                                colors: [
                              AppColors.primaryColor,
                              AppColors.secondryColor,
                            ])),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: controller.imageFile != null
                          ? Stack(
                              children: [
                                Center(
                                  child: Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      width: getWidth(140),
                                      height: getHeight(140),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      child: Image.file(
                                        controller.imageFile!,
                                        width: 140,
                                        height: 140,
                                        fit: BoxFit.fill,
                                      )),
                                ),
                              ],
                            )
                          : CustomNetworkImage(
                              imageUrl: PreferenceUtils.getString(
                                  SharedPreferencesConst.image),
                              width: 140,
                              height: 140,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 110,
                      right: 0,
                      child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black),
                          child: IconButton(
                              onPressed: () {
                                controller.onGetImage(isCamera: false);
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                              ))),
                    )
                  ],
                ),
                SizedBox(
                  height: getHeight(15),
                ),
                const ShowAndEditNameItem(),
                const Spacer(),
                AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: controller.imageFile != null ||
                            controller.nameController.text.trim().isNotEmpty
                        ? getHeight(70)
                        : 0,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: controller.imageFile != null ||
                              controller.nameController.text.trim().isNotEmpty
                          ? 1
                          : 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getWidth(40), vertical: getHeight(5)),
                        child: controller.isLoadingUplading
                            ? const LoadingItem()
                            : AppButton(
                                onTap: () {
                                  controller.changeImageOrName(context);
                                },
                                head: "Update Profile"),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(40), vertical: getHeight(5)),
                  child: AppButton(onTap: () {}, head: "Reset Password"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(40), vertical: getHeight(5)),
                  child: AppButton(
                    onTap: () async {
                      controller.logOut(context);
                    },
                    head: "Log Out",
                    color: Colors.red.shade700,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
