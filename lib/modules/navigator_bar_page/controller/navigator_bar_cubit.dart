import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havefun/modules/upload/view/upload_screen.dart';

import '../../../core/utils/function/need_login_model_sheet.dart';
import '../../../core/utils/function/shared_prefrance_utils.dart';
import '../../../core/utils/shared_preferance_const.dart';
import '../../home_page/view/home_page_screen.dart';
import '../../profile/view/profile_screen.dart';

part 'navigator_bar_state.dart';

class NavigatorBarCubit extends Cubit<NavigatorBarState> {
  NavigatorBarCubit() : super(NavigatorBarInitial());
  static NavigatorBarCubit get(context) => BlocProvider.of(context);

  int selectedPage = 0;
  List<Widget> pages = [
    const HomePageScreen(),
    UploadScreen(),
    const ProfileScreen()
  ];
  onChangePage({required int pageIndex, context}) {
    debugPrint(
        "uid : ${PreferenceUtils.getString(SharedPreferencesConst.uid)}");
    debugPrint("page num$selectedPage");
    if (pageIndex == 0) {
      selectedPage = pageIndex;
      emit(ChangePageIndexState());
    } else {
      if (PreferenceUtils.getString(SharedPreferencesConst.uid).isNotEmpty) {
        selectedPage = pageIndex;
        emit(ChangePageIndexState());
      } else {
        needLogin(context: context);
      }
    }
  }

  initial({required int selectedPage}) {
    this.selectedPage = selectedPage;
    emit(StartingPageState());
  }
}
