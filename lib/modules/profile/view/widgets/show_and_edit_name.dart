import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/function/shared_prefrance_utils.dart';
import 'package:havefun/core/utils/shared_preferance_const.dart';

import '../../../../core/utils/function/validate.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../controller/profile_cubit.dart';

class ShowAndEditNameItem extends StatelessWidget {
  const ShowAndEditNameItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final controller = ProfileCubit.get(context);
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: controller.isEditName ? getHeight(70) : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: controller.isEditName ? 1 : 0,
                child: Row(children: [
                  SizedBox(
                    width: getWidth(10),
                  ),
                  Expanded(
                    child: TextFieldItem(
                        lable: "Edit Name",
                        onValidate: (name) => Validate.validateName(name),
                        controller: controller.nameController,
                        fristIcon: Icons.edit),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: getWidth(10)),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: IconButton(
                        onPressed: () {
                          controller.changeName();
                        },
                        icon: const Icon(Icons.close)),
                  )
                ]),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: controller.isEditName ? 0 : getHeight(50),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: controller.isEditName ? 0 : 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      PreferenceUtils.getString(SharedPreferencesConst.name),
                      style: TextStyle(
                        fontSize: getFont(25),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          controller.changeName();
                          
                        },
                        icon: const Icon(Icons.edit_rounded))
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
