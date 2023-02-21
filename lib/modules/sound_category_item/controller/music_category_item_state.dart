part of 'music_category_item_cubit.dart';
 
abstract class MusicCategoryItemState {}

class MusicCategoryItemInitial extends MusicCategoryItemState {}
class LoadingCategoryState extends MusicCategoryItemState {}
class SuccessCategoryState extends MusicCategoryItemState {}
class FaildCategoryState extends MusicCategoryItemState {}
