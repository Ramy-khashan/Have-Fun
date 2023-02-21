import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/app_colors.dart';
import 'package:havefun/core/utils/size_config.dart';

import '../controller/navigator_bar_cubit.dart';

class NavigatorBarPageScreen extends StatelessWidget {
  final int selectedPage;
  const NavigatorBarPageScreen({Key? key,   this.selectedPage=0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => NavigatorBarCubit()..initial(selectedPage:selectedPage),
      child: BlocBuilder<NavigatorBarCubit, NavigatorBarState>(
        builder: (context, state) {
          final controller = NavigatorBarCubit.get(context);

          return Scaffold(
            body: Center(child: controller.pages[controller.selectedPage]),
            bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: AppColors.secondryColor,
                onTap: (value) {
                  controller.onChangePage(pageIndex: value,context: context);
                },
                currentIndex: controller.selectedPage,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      size: getWidth(30),
                    ),
                    label: "",
                  ), BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      size: getWidth(30),
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person_pin,
                        size: getWidth(30),
                      ),
                      label: "")
                ]),
          );
        },
      ),
    );
  }
}
