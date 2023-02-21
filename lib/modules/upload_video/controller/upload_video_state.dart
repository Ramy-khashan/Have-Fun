part of 'upload_video_cubit.dart';

@immutable
abstract class UploadVideoState {}

class UploadVideoInitial extends UploadVideoState {}
class InitializeVideoState extends UploadVideoState {}
class LoadingUploadVideoState extends UploadVideoState {}
class SuccessUploadVideoState extends UploadVideoState {}
class FaildUploadVideoState extends UploadVideoState {}
