part of 'sign_up_cubit.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class ChangeViewPasswordState extends SignUpState {}

class LoadingSignUpState extends SignUpState {}

class SuccessSignUpState extends SignUpState {}

class FaildSignUpState extends SignUpState {}
