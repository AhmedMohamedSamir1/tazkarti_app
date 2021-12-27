 import 'package:firebase_auth/firebase_auth.dart';
import 'package:tazkarti_system/shared/network/cash_helper.dart';
import 'package:tazkarti_system/shared/network/firebase_class.dart';

String? uId ;



//----start logout ---------

 Future<void> logOut({
   required String authType, required context,
 }) async
 {
   if(authType == 'emailPassword'){
     await FirebaseAuth.instance.signOut();
   }
   else{
     await FireBaseClass.signOutFromGoogle(context: context);
   }

 }
 //----end logout ----