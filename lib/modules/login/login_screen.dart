// ignore_for_file: sized_box_for_whitespace, use_key_in_widget_constructors, avoid_print, curly_braces_in_flow_control_structures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:tazkarti_system/modules/admin_layout/tazkarti_admin_layout.dart';
import 'package:tazkarti_system/modules/login/cubit.dart';
import 'package:tazkarti_system/modules/login/states.dart';
import 'package:tazkarti_system/modules/register/register_screen.dart';
import 'package:tazkarti_system/modules/user_layout/tazkarti_user_layout.dart';
import 'package:tazkarti_system/shared/components/components.dart';
import 'package:tazkarti_system/shared/components/constants.dart';
import 'package:tazkarti_system/shared/network/cash_helper.dart';
import 'package:tazkarti_system/shared/network/firebase_class.dart';


// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey <FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (BuildContext context) { return TazkartiLoginCubit(); },
      child: BlocConsumer<TazkartiLoginCubit, TazkartiLoginStates>(
        listener: (context, state){

          if(state is TazkartiLoginSuccessState) {
            CashHelper.saveData(key: 'uId', value: state.uId);
            CashHelper.saveData(key: 'authType', value: state.authType);
            uId = state.uId;
            if(state.userEmail == 'ahmedmohamedmvp@gmail.com') {
              CashHelper.saveData(key: 'isAdmin', value: true);
              navigateAndFinish(context, TazkartiAdminLayout());
            }
            else
              navigateAndFinish(context, TazkartiUserLayout());
          }

        },
        builder: (context, state){


          var cubit = TazkartiLoginCubit.get(context);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  children:  [

                    const Expanded(
                      flex: 2,
                      child: Image(
                        image: AssetImage("assets/images/login6.jpg"),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Text(
                      'login now to reserve tickets and enjoy watching the competitive matches',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.grey[800]
                      ),
                    ),

                    const SizedBox(height: 15,),

                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 5,),
                            defaultTextFormField(
                              fieldController: emailController,
                              inputType: TextInputType.emailAddress,
                              validator: (String? value){
                                if(value!.isEmpty)
                                  return "email can't be empty";
                              },
                              labelText: 'Email',
                              prefixIcon: Icons.email_outlined,
                              borderRadius: 15,
                              elevation: 5,

                            ),

                            const SizedBox(height: 15,),

                            defaultTextFormField(
                              fieldController: passwordController,
                              inputType: TextInputType.visiblePassword,
                              validator: (String? value){
                                if(value!.isEmpty)
                                  return "password can't be empty";
                              },
                              labelText: 'password',
                              prefixIcon: Icons.lock_outlined,
                              suffixIcon: cubit.passVisibilityIcon,
                              suffixClicked: (){
                                cubit.changePassVisibility();
                              },
                              borderRadius: 15,
                              elevation: 5,
                              obscureText: cubit.passVisibility,
                            ),
                            const SizedBox(height: 15,),

                            Conditional.single(
                                context: context,
                                conditionBuilder: (context)=> state is! TazkartiLoginLoadingState,
                                widgetBuilder: (context)=> defaultMaterialButton(
                                    onPressed: (){
                                      if(formKey.currentState!.validate()){
                                        cubit.loginByEmailAndPass(email: emailController.text, password: passwordController.text);
                                      }
                                    },
                                    text: 'login',
                                    radius: 15,
                                    gradientColorsList: [
                                      Colors.blue,
                                      Colors.blue.withOpacity(0.5)
                                    ],
                                    boxShadowColor: Colors.blue
                                ),
                                fallbackBuilder: (context)=>const CircularProgressIndicator()
                            ),

                            const SizedBox(height:   15,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "don't have an account ?",
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.grey[800]
                                  ),
                                ),
                                TextButton(
                                    onPressed: (){
                                      navigateTo(context, RegisterScreen());
                                    },
                                    child: const Text('Register Now'))
                              ],
                            ),

                            const SizedBox(height: 5,),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Text(
                                  ' OR ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),

                            Container(
                              width: double.infinity,

                              child: SignInButton(
                                Buttons.Google,
                                elevation: 4,
                                onPressed: (){
                                cubit.signInByGoogle(context);

                                },
                                text: 'Continue With Google',),

                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          },
      ),
    );
  }



}

//log in now to reserve tickets and enjoy watching the competitive matches