// ignore_for_file: sized_box_for_whitespace, use_key_in_widget_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:tazkarti_system/modules/admin_layout/tazkarti_admin_layout.dart';

import 'package:tazkarti_system/modules/register/cubit.dart';
import 'package:tazkarti_system/modules/register/states.dart';
import 'package:tazkarti_system/modules/user_layout/tazkarti_user_layout.dart';
import 'package:tazkarti_system/shared/components/components.dart';
import 'package:tazkarti_system/shared/components/constants.dart';
import 'package:tazkarti_system/shared/network/cash_helper.dart';
import 'package:tazkarti_system/shared/network/firebase_class.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatelessWidget {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey <FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) { return TazkartiRegisterCubit(); },
      child: BlocConsumer<TazkartiRegisterCubit, TazkartiRegisterStates>(
        listener: (context, state) {

          if(state is TazkartiRegisterSuccessState) {
            CashHelper.saveData(key: 'uId', value: state.uId);
            CashHelper.saveData(key: 'authType', value: 'emailPassword');
            uId = state.uId;
            navigateAndFinish(context, TazkartiUserLayout());
          }

        },
        builder: (context, state) {
          var cubit = TazkartiRegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Registration',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children:  [

                     const Image(
                      image: AssetImage("assets/images/registration6.jpg"),
                       width: double.infinity,
                       height: 180,
                       fit: BoxFit.cover,
                    ),

                    const SizedBox(height: 15,),

                    Text(
                      'login now to reserve tickets and enjoy watching the competitive matches',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.grey[800]
                      ),
                    ),

                    const SizedBox(height: 15,),

                    Form(

                      key: formKey,
                      child: Column(
                        children: [

                          defaultTextFormField(
                            fieldController: nameController,
                            inputType: TextInputType.name,
                            validator: (String? value){
                              if(value!.isEmpty) {

                                return "name can't be empty";
                              }
                            },
                            labelText: 'Name',
                            prefixIcon: Icons.person,
                            borderRadius: 15,
                            elevation: 5,

                          ),

                          const SizedBox(height: 15,),

                          defaultTextFormField(
                            fieldController: emailController,
                            inputType: TextInputType.emailAddress,
                            validator: (String? value){
                              if(value!.isEmpty) {
                                return "email can't be empty";
                              }
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
                              obscureText: cubit.passVisibility,
                              validator: (String? value){
                                if(value!.isEmpty) {
                                  return "password can't be empty";
                                }
                              },
                              labelText: 'Password',
                              prefixIcon: Icons.lock_outlined,
                              suffixIcon: cubit.passVisibilityIcon,
                              suffixClicked: (){
                                cubit.changePassVisibility();
                              },
                              borderRadius: 15,
                              elevation: 5
                          ),
                          const SizedBox(height: 15,),


                          defaultTextFormField(
                              fieldController: confirmPasswordController,
                              inputType: TextInputType.visiblePassword,
                              obscureText: cubit.confirmPassVisibility,
                              validator: (String? value){
                                if(value!.isEmpty) {
                                  return "password can't be empty";
                                }
                                if(confirmPasswordController.text != passwordController.text){
                                  return "password must be identical";
                                }
                              },
                              labelText: 'Confirm Password',
                              prefixIcon: Icons.lock_outlined,
                              suffixIcon: cubit.confirmPassVisibilityIcon,
                              suffixClicked: (){
                                cubit.changeConfirmPassVisibility();

                              },
                              borderRadius: 15,
                              elevation: 5
                          ),
                          const SizedBox(height: 15,),

                          defaultTextFormField(
                              fieldController: phoneController,
                              inputType: TextInputType.phone,
                              validator: (String? value){
                                if(value!.isEmpty) {
                                  return "phone can't be empty";
                                }
                              },
                              labelText: 'Phone',
                              prefixIcon: Icons.phone,

                              borderRadius: 15,
                              elevation: 5
                          ),
                          const SizedBox(height: 15,),

                          Conditional.single(
                              context: context,
                              conditionBuilder:(context) => state is! TazkartiRegisterLoadingState,
                              widgetBuilder: (context) => defaultMaterialButton(
                                  onPressed: (){
                                    if(formKey.currentState!.validate()) {
                                      cubit.registerByEmailAndPass( name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                          phone: phoneController.text,

                                      );
                                    }
                                  },
                                  text: 'Register',
                                  radius: 15,
                                  gradientColorsList: [
                                    Colors.blue,
                                    Colors.blue.withOpacity(0.5)
                                  ],
                                  boxShadowColor: Colors.blue
                              ),
                              fallbackBuilder:(context)=> Container(
                                height: 20,
                                child: LoadingBouncingLine.circle(
                                  borderColor: Colors.blue,
                                  backgroundColor: Colors.blue,
                                  borderSize: 3.0,
                                  size: 80.0,
                                  duration:  const Duration(milliseconds: 1000),

                                ),
                              )
                          ),
                          const SizedBox(height: 10,),


                        ],
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
// https://sportteamslogo.com/api?key=2fc4f5d0d1d6456e92f032135a2c544c&size=small&tid=5737
// api key = 2fc4f5d0d1d6456e92f032135a2c544c  //sportteamslogo
// https://sportteamslogo.com/api?key=2fc4f5d0d1d6456e92f032135a2c544c&size=big&tid=77889  //sportteamslogo

// 0d1952e5a8254528af8a74b9713cf6e1  // gerges
//------------------------------------------

// https://newsapi.org/v2/top-headlines?country=eg&category=business&apiKey=ab7ecf1f3303492aa5ffcebd1ed60e6d

//--------------------------
// api key = f4b8ce209a514233a873dc2c6cc4dbb3