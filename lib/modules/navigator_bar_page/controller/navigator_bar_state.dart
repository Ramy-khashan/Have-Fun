part of 'navigator_bar_cubit.dart';

@immutable
abstract class NavigatorBarState {}

class NavigatorBarInitial extends NavigatorBarState {}
class ChangePageIndexState extends NavigatorBarState {}
class StartingPageState extends NavigatorBarState {}
