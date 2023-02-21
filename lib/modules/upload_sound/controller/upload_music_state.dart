part of 'upload_music_cubit.dart';
 
abstract class UploadMusicState {}

class UploadMusicInitial extends UploadMusicState {}
class LoadingAudioState extends UploadMusicState {}
class PausedAudioState extends UploadMusicState {}
class PlayingAudioState extends UploadMusicState {}
class PickMusicState extends UploadMusicState {}
class LoadingMusicUploadState extends UploadMusicState {}
class SuccessMusicUploadState extends UploadMusicState {}
class FaildMusicUploadState extends UploadMusicState {}
class ChangeCategoryState extends UploadMusicState {}
