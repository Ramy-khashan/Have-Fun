import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/model_music.dart';

part 'music_category_item_state.dart';

class MusicCategoryItemCubit extends Cubit<MusicCategoryItemState> {
  MusicCategoryItemCubit() : super(MusicCategoryItemInitial());
  static MusicCategoryItemCubit get(context) => BlocProvider.of(context);
  List<MusicModel> musicList = [];
  bool isLoadingcategory = false;
  getMusicCaegoryItme({required String category}) async {
    isLoadingcategory = true;
    emit(LoadingCategoryState());
    try {
      await FirebaseFirestore.instance
          .collection("audio")
          .where("category", isEqualTo: category.trim())
          .get()
          .then((value) {
        log(value.docs.length.toString());
        for (var element in value.docs) {
          musicList.add(MusicModel.fromJson(element.data()));
        } 
        isLoadingcategory = false;
        emit(SuccessCategoryState());
      }).onError<FirebaseException>((error, stackTrace) {
        isLoadingcategory = false;
        debugPrint(error.toString());
        musicList = [];
        emit(SuccessCategoryState());
      });
    } catch (e) {
      debugPrint(e.toString());
      isLoadingcategory = false;
      musicList = [];

      emit(SuccessCategoryState());
    }
  }
}
