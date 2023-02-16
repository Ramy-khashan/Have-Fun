part of 'sound_cubit.dart';
 
abstract class SoundState {}

class SoundInitial extends SoundState {}

class LoadingAudioState extends SoundState {}
class PlayingAudioState extends SoundState {}
class PausedAudioState extends SoundState {}
class GetDurationState extends SoundState {}
class ChangeAudioVolumeState extends SoundState {}
