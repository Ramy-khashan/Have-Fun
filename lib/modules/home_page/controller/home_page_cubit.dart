
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/core/utils/app_assets.dart';
import '../model/home_page_model.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageInitial());
  static HomePageCubit get(context) => BlocProvider.of(context);
  final pageViewControlle =
      PageController(viewportFraction: .9, initialPage: 1);

  int selectedIndex = 1;
  List<HomePageModel> pagesInfo = [
    HomePageModel(
        title: "Videos",
        subTitle: "Show New Videos Shared by Friends and have fun...",
        imageLink: AppAssets.videoImage),
    HomePageModel(
        title: "Music",
        subTitle: "Listen New Music Shared by Friends and have fun...",
        imageLink: AppAssets.musicImage),
    HomePageModel(
        title: "Memes",
        subTitle: "View New Memes Shared by Friends and have fun...",
        imageLink: AppAssets.splashImg),
  ];
  onChangePage(index) {
    selectedIndex = index;
    emit(ChangePageScreen());
  }
}
