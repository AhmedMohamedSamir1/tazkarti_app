import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazkarti_system/modules/admin_layout/cubit.dart';
import 'package:tazkarti_system/modules/login/login_screen.dart';
import 'package:tazkarti_system/modules/onBoarding_screen/on_boarding.dart';
import 'package:tazkarti_system/modules/user_layout/cubit.dart';
import 'package:tazkarti_system/shared/bloc_observer.dart';
import 'package:tazkarti_system/shared/components/constants.dart';
import 'package:tazkarti_system/shared/network/cash_helper.dart';
import 'package:tazkarti_system/shared/styles/themes.dart';

import 'modules/admin_layout/tazkarti_admin_layout.dart';
import 'modules/user_layout/tazkarti_user_layout.dart';

void main()async {

  WidgetsFlutterBinding.ensureInitialized();

  // BlocOverrides.runZoned(() {
  //
  // }, blocObserver: MyBlocObserver());

  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp();

  await CashHelper.init();
  uId = CashHelper.getSavedData(key: 'uId');

  Widget startScreen = LoginScreen();
  bool? onBoarding = CashHelper.getSavedData(key: "passOnBoarding");
  bool? isAdmin = CashHelper.getSavedData(key: "isAdmin");

  if(onBoarding==null) {
    startScreen = const OnBoardingScreen();
  }
  else if(isAdmin==true){
    startScreen = TazkartiAdminLayout();
  }
  else if(uId!=null){
    startScreen = TazkartiUserLayout();
  }


  runApp(MyApp(startScreen));
}

class MyApp extends StatelessWidget {
  Widget startScreen;
  MyApp(this.startScreen);






  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers: [
        BlocProvider(create: (BuildContext context) { return TazkartiAdminCubit()..readTeamsFile()..readStadiumsFile()..getAllMatches(); },),
          BlocProvider(create: (BuildContext context) { return TazkartiUserCubit()..getAllMatches()..getUserReservation(); },),
    ],
    child:
      MaterialApp(
          theme: lightTheme,
          debugShowCheckedModeBanner: false,
          home: startScreen
      )
    );
  }
}
