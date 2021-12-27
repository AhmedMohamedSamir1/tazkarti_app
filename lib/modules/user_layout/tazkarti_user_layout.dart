


// ignore_for_file: use_key_in_widget_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tazkarti_system/modules/login/login_screen.dart';
import 'package:tazkarti_system/modules/user_layout/states.dart';
import 'package:tazkarti_system/shared/components/components.dart';
import 'package:tazkarti_system/shared/components/constants.dart';
import 'package:tazkarti_system/shared/network/cash_helper.dart';
import 'package:tazkarti_system/shared/styles/icon_broken.dart';

import 'cubit.dart';

class TazkartiUserLayout extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<TazkartiUserCubit, TazkartiUserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TazkartiUserCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor('104B2B'),
            centerTitle: true,
            title: Text(
                cubit.titles[cubit.currentIndex],
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.white,
                )
            ),
            actions:
            [
              IconButton(
                icon: const Icon(
                  IconBroken.Search,
                  color: Colors.white,
                ),
                onPressed: (){},
              ),
              IconButton(
                icon: const Icon(
                  IconBroken.Logout,
                  color: Colors.white,
                ),
                onPressed: (){

                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.INFO,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Logout',
                    desc: 'Are you sure that you want to Logout',
                    btnCancelOnPress: () {
                    },
                    btnOkOnPress: () {

                      String authType = CashHelper.getSavedData(key: 'authType');
                      logOut(authType: authType, context: context)
                          .then((value) {
                        CashHelper.removeData(key: 'uId');
                        CashHelper.removeData(key: 'authType');
                        navigateAndFinish(context, LoginScreen());
                      });

                    },
                  ).show();
                },
              ),


            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: CurvedNavigationBar(
            height: 50,
            backgroundColor: Colors.green.shade600,
            index: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeBottomNavBar(index);
            },
            items: cubit.bottomItems,
          ),

        );
      },
    );
  }
}