part of 'upload_memes_cubit.dart';

abstract class UploadMemesState {}

class UploadMemesInitial extends UploadMemesState {}
class SuccessGetImageState extends UploadMemesState {}
class FaildGetImageState extends UploadMemesState {}
class LoadingUploadMemesState extends UploadMemesState {}
class SuccessUploadMemesState extends UploadMemesState {}
class FaildUploadMemesState extends UploadMemesState {}
