// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazkarti_system/models/user_model.dart';
import 'package:tazkarti_system/modules/register/states.dart';
import 'package:tazkarti_system/shared/components/components.dart';
import 'package:tazkarti_system/shared/network/firebase_class.dart';

class TazkartiRegisterCubit extends Cubit<TazkartiRegisterStates>{

  TazkartiRegisterCubit() : super(TazkartiRegisterInitialState());

  static TazkartiRegisterCubit get(context)
  {
    return BlocProvider.of(context);
  }

  //-------start password visibility-------
  bool passVisibility = true;
  IconData passVisibilityIcon  = Icons.visibility_off_outlined;
  void changePassVisibility()
  {
    passVisibility = !passVisibility;
    passVisibilityIcon =  passVisibility?  Icons.visibility_off_outlined:Icons.visibility_outlined;
    emit(TazkartiRegisterChangePassState());
  }
  //-------end password visibility---------

  //---start confirm password visibility----
  bool confirmPassVisibility = true;
  IconData confirmPassVisibilityIcon  = Icons.visibility_off_outlined;
  void changeConfirmPassVisibility()
  {
    confirmPassVisibility = !confirmPassVisibility;
    confirmPassVisibilityIcon = confirmPassVisibility?Icons.visibility_off_outlined:Icons.visibility_outlined;
    emit(TazkartiRegisterChangePassState());

  }
  //---end confirm password visibility-------

  //-----start registration by email and password-----

  void registerByEmailAndPass({
    required String name,
    required String email,
    required String password,
    required String phone,

  })
  {
   emit(TazkartiRegisterLoadingState());
    FireBaseClass.registerByEmailAndPass(email: email, password: password).then((value) {

      String uId = value.user!.uid;

      UserModel user = UserModel(uId: uId, name: name, email: email, phone: phone);

      FireBaseClass.addToFireSore(collectionName: 'user', docName: uId, model: user.toMap()).then((value) {
        emit(TazkartiRegisterSuccessState(uId));
      }).catchError((onError){

        emit(TazkartiRegisterErrorState());
        print(onError.toString());
        toastMessage(textMessage: onError.toString(), toastState: ToastStates.ERROR);
      });
    }).catchError((onError){
      print(onError.toString());
      toastMessage(textMessage: onError.toString(), toastState: ToastStates.ERROR);
      emit(TazkartiRegisterErrorState());
    });
  }
  //-----end registration by email and password-----
}