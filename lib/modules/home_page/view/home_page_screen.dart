import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/size_config.dart';
import 'package:havefun/modules/home_page/controller/home_page_cubit.dart';
import 'package:havefun/modules/videos/view/videos_screen.dart';

import '../../../core/widgets/head_shape.dart';
import '../../memes/view/memes_screen.dart';
import '../../sound/view/sound_screen.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocProvider(
      create: (context) => HomePageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Have Fun",
            style: TextStyle(
              fontSize: getFont(40),
            ),
          ),
        ),
        body: BlocBuilder<HomePageCubit, HomePageState>(
          builder: (context, state) {
            final controller = HomePageCubit.get(context);
            return PageView(
              onPageChanged: (value) {
                controller.onChangePage(value);
              },
              controller: controller.pageViewControlle,
              children: List.generate(
                controller.pagesInfo.length,
                (index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => controller.selectedIndex == 0
                                ? const VideosScreen()
                                : controller.selectedIndex == 1
                                    ? const SoundScreen()
                                    : const MemesScreen()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getWidth(10),
                        vertical: getHeight(
                            controller.selectedIndex == index ? 15 : 50)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.6),
                          spreadRadius: 3,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: getHeight(20),
                        ),
                        HeadShape(
                            height: 18,
                            width: 40,
                            headFontSize: 25,
                            head: controller.pagesInfo[index].title),
                        SizedBox(
                          height: getHeight(20),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: getWidth(15)),
                          child: Text(
                            controller.pagesInfo[index].subTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: getFont(24),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(getWidth(25)),
                            child: Image.asset(
                                controller.pagesInfo[index].imageLink),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
