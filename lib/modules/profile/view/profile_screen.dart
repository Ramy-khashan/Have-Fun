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

import '../../../core/utils/function/log_out.dart';
import 'widgets/profile_clip_path.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode focusScopeNode = FocusScope.of(context);
          if (!focusScopeNode.hasPrimaryFocus) {
            return focusScopeNode.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
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
                      c],
                    ),
                    SizedBox(
                      height: getHeight(15),
                    ),
                    const ShowAndEditNameItem(),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: controller.imageFile != null ||
                              controller.nameController.text.trim().isNotEmpty
                          ? 180
                          : 250,
                    ),
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: controller.imageFile != null ||
                                controller.nameController.text.trim().isNotEmpty
                            ? getHeight(70)
                            : 0,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: controller.imageFile != null ||
                                  controller.nameController.text
                                      .trim()
                                      .isNotEmpty
                              ? 1
                              : 0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidth(40),
                                vertical: getHeight(5)),
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
                      child: AppButton(
                          onTap: ()async {
                           await controller.resetPassword();
                          },
                          head: "Reset Password"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidth(40), vertical: getHeight(5)),
                      child: AppButton(
                        onTap: () async {
                          logOut(context);
                        },
                        head: "Log Out",
                        color: Colors.red.shade700,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
