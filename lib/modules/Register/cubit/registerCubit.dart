import 'package:deepfake_detection/models/RegisterModel/RegisterModel.dart';
import 'package:deepfake_detection/modules/Register/cubit/registerStates.dart';
import 'package:deepfake_detection/shared/network/end_points.dart';
import 'package:deepfake_detection/shared/network/remote/main_dio_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/constants.dart';

class RegisterCubit extends Cubit<RegisterStates>
{
  RegisterCubit(): super(RegisterInitialState());

  static RegisterCubit get(context)=> BlocProvider.of(context);

  bool isPassVisible=true;


  void changePassVisibility()
  {
    isPassVisible=!isPassVisible;
    emit(RegisterChangePassVisibility());
  }

  RegisterModel? registerModel;
  void registerUser({required String name, required String lastName, required String gender, required String birthDate, required String password, required String email})
  {
    print('In RegisterUser...');

    emit(RegisterLoadingState());

    MainDioHelper.postData(
      url: register,
      isStatusCheck: true,
      data: {
        'name':name,
        'last_name':lastName,
        'gender':gender,
        'birthDate':birthDate,
        'password':password,
        'email':email,
        if(firebaseToken !=null && firebaseToken != '') 'firebaseToken':firebaseToken,
      },
    ).then((value) {

      print('Got RegisterData, ${value.data}');

      registerModel=RegisterModel.fromJson(value.data);

      emit(RegisterSuccessState(registerModel!));
    }).catchError((error)
    {
        print('ERROR WHILE SIGNING IN, ${error.toString()}');
        emit(RegisterErrorState(error.toString()));
    });
  }
}