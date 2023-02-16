part of 'videos_cubit.dart';
 
abstract class VideosState {}

class VideosInitial extends VideosState {}

class VideoInitial extends VideosState {}
class PalyVideoState extends VideosState {}
class PauseVideoState extends VideosState {}
class SpeedVideoState extends VideosState {}
class SeekVideoState extends VideosState {}
class ChangeVolumeVideoState extends VideosState {}
class LoadingVideoState extends VideosState {}
class InstializeVideoState extends VideosState {} 
class VideoEndState extends VideosState {} 
