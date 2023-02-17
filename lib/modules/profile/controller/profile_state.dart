part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class SuccessGetImageState extends ProfileState {}

class FaildGetImageState extends ProfileState {}
class ToChangeNameState extends ProfileState {}
class LoadingUpdateState extends ProfileState {}
class SuccessUpdateState extends ProfileState {}
class FaildUpdateState extends ProfileState {}
