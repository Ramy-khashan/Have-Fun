part of 'upload_cubit.dart';

abstract class UploadState {}

class UploadInitial extends UploadState {}

class InitializeVideoState extends UploadState {}

class FaildUploadVideoState extends UploadState {}

class LoadingUploadVideoState extends UploadState {}

class SuccessUploadVideoState extends UploadState {}
