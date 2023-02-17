import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/app_colors.dart';
import 'package:havefun/modules/upload/controller/upload_cubit.dart';

import '../../../core/utils/size_config.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: BlocProvider.of<UploadCubit>(context).tabBarTitle.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(.5),
              AppColors.secondryColor,
            ], end: Alignment.bottomCenter, begin: Alignment.topCenter)),
          ),
          title: Text(
            "Uplading",
            style: TextStyle(
              fontSize: getFont(40),
              fontWeight: FontWeight.w500,
            ),
          ),
          bottom: TabBar(
             
              indicatorColor: Colors.white,
              labelStyle: TextStyle(
                  fontFamily: "splash",
                  fontSize: getFont(25),
                  fontWeight: FontWeight.w700),
              tabs: List.generate(
                  BlocProvider.of<UploadCubit>(context).tabBarTitle.length,
                  (index) => Tab(
                        text: BlocProvider.of<UploadCubit>(context)
                            .tabBarTitle[index],
                      ))),
        ),
        body: TabBarView(
            children: List.generate(
                BlocProvider.of<UploadCubit>(context).pages.length,
                (index) => BlocProvider.of<UploadCubit>(context).pages[index])),
      ),
    );
  }
}
