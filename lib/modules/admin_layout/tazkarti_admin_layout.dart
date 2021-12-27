


// ignore_for_file: use_key_in_widget_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tazkarti_system/modules/admin_layout/states.dart';
import 'package:tazkarti_system/modules/login/login_screen.dart';
import 'package:tazkarti_system/shared/components/components.dart';
import 'package:tazkarti_system/shared/components/constants.dart';
import 'package:tazkarti_system/shared/network/cash_helper.dart';
import 'package:tazkarti_system/shared/styles/icon_broken.dart';

import 'cubit.dart';

class TazkartiAdminLayout extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<TazkartiAdminCubit, TazkartiAdminStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var cubit = TazkartiAdminCubit.get(context);


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
                onPressed: (){
                  cubit.showSearchTextFormField();

                },
              ),
              IconButton(
                icon: const Icon(
                  IconBroken.Logout,
                  color: Colors.white,
                ),
                onPressed: (){

                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
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
                            uId = null;
                            CashHelper.removeData(key: 'authType');
                            CashHelper.removeData(key: 'isAdmin');
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