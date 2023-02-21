part of 'memes_cubit.dart';

abstract class MemesState {}

class MemesInitial extends MemesState {}

class LoadingMemesState extends MemesState {}

class SuccessMemesState extends MemesState {}

class FaildMemesState extends MemesState {}
