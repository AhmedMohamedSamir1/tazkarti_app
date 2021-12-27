// ignore_for_file: avoid_print


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:tazkarti_system/models/user_model.dart';
import 'package:tazkarti_system/modules/admin_layout/tazkarti_admin_layout.dart';
import 'package:tazkarti_system/modules/login/states.dart';
import 'package:tazkarti_system/modules/register/states.dart';
import 'package:tazkarti_system/shared/components/basics.dart';
import 'package:tazkarti_system/shared/components/components.dart';
import 'package:tazkarti_system/shared/network/firebase_class.dart';

class TazkartiLoginCubit extends Cubit<TazkartiLoginStates>{

  TazkartiLoginCubit() : super(TazkartiLoginInitialState());

  static TazkartiLoginCubit get(context)
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
    emit(TazkartiLoginChangePassState());
  }
  //-------end password visibility---------


  //-----start login by email and password-----

  void loginByEmailAndPass({

    required String email,
    required String password,

  })
  {
   emit(TazkartiLoginLoadingState());

    FireBaseClass.userLogInByEmailAndPass(email: email, password: password).then((value) {
      String uId = value.user!.uid;
      String userEmail = value.user!.email!;
      emit(TazkartiLoginSuccessState(uId, userEmail, 'emailPassword'));

    }).catchError((onError){
      print(onError.toString());
      toastMessage(textMessage: onError.toString(), toastState: ToastStates.ERROR);
      emit(TazkartiLoginErrorState());
    });
  }
  //-----end login by email and password-----


  //----- start login by google -----
  void signInByGoogle(context){
    print('///////////////////////////////////////////////');
    FireBaseClass.signInWithGoogle(context: context).then((value){

       if(value!=null) {
         String uId = value.uid.toString();
         String userEmail = value.email.toString();

         if (FirebaseAuth.instance.currentUser!.metadata.creationTime ==
             FirebaseAuth.instance.currentUser!.metadata.lastSignInTime)
         {
           String userName = value.displayName.toString();
           String phone = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
           print('phone------------------> '+phone);
           UserModel model = UserModel(uId: uId, name: userName, email: userEmail, phone: phone);
           FireBaseClass.addToFireSore(collectionName: 'user', docName: uId, model: model.toMap());
         }
         emit(TazkartiLoginSuccessState(uId, userEmail,'google'));
       }
    }).catchError((onError){
      toastMessage(textMessage: onError.toString(), toastState: ToastStates.ERROR);
      emit(TazkartiLoginErrorState());
      print(onError.toString());
    });
  }
  //----- end login by google -----

}