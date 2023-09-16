import 'package:deepfake_detection/models/RegisterModel/RegisterModel.dart';

abstract class RegisterStates{}

class RegisterInitialState extends RegisterStates{}


class RegisterChangePassVisibility extends RegisterStates{}

class RegisterLoadingState extends RegisterStates{}

class RegisterErrorState extends RegisterStates{
  final String error;

  RegisterErrorState(this.error);
}


class RegisterSuccessState extends RegisterStates{

  final RegisterModel registerModel;

  RegisterSuccessState(this.registerModel);
}