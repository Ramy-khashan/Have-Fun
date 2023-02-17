import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/modules/upload/view/upload_screen.dart';

import '../../home_page/view/home_page_screen.dart';
import '../../profile/view/profile_screen.dart';

part 'navigator_bar_state.dart';

class NavigatorBarCubit extends Cubit<NavigatorBarState> {
  NavigatorBarCubit() : super(NavigatorBarInitial());
  static NavigatorBarCubit get(context) => BlocProvider.of(context);

  int selectedPage = 0;
  List<Widget> pages = [const HomePageScreen(),UploadScreen(), const ProfileScreen()];
  onChangePage({required int pageIndex}) {
    selectedPage = pageIndex;
    emit(ChangePageIndexState());
  }

  initial({required int selectedPage}) {
    this.selectedPage = selectedPage;
    emit(StartingPageState());
  }
}
