part of 'sign_in_cubit.dart';
 
abstract class SignInState {}

class SignInInitial extends SignInState {}
class ChangeViewPasswordState extends SignInState {}
class LoadingSignInState extends SignInState {}

class SuccessSignInState extends SignInState {}

class FaildSignInState extends SignInState {}
