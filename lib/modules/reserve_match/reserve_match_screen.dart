
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_image/network.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:tazkarti_system/models/match_model.dart';
import 'package:tazkarti_system/modules/map/map.dart';
import 'package:tazkarti_system/modules/user_layout/cubit.dart';
import 'package:tazkarti_system/modules/user_layout/states.dart';
import 'package:tazkarti_system/modules/user_layout/tazkarti_user_layout.dart';
import 'package:tazkarti_system/shared/components/components.dart';
import 'package:tazkarti_system/shared/styles/icon_broken.dart';
import 'package:geocoding/geocoding.dart';

class ReserveMatchScreen extends StatelessWidget {

  MatchModel match;
  GlobalKey <FormState> formKey = GlobalKey<FormState>();
  int numOfTickets = 1;
   ReserveMatchScreen({Key? key,
    required this.match
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<TazkartiUserCubit, TazkartiUserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TazkartiUserCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor('104B2B'),
            leading: IconButton(
              icon: const Icon(IconBroken.Arrow___Left_2, color: Colors.white,size: 28,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Text(
                'Reserve a ticket',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.white,
                )
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(            // make outlined border to container
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    match.firstTeam,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontSize: 14),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                //if (key1 != null)
                                Expanded(
                                  child: Image(
                                    image: NetworkImage(
                                        match.firstTeamLogo
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      match.matchDate,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      match.matchTime,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(fontSize: 14),
                                    ),
                                  ],
                                ),
                                // if (key2 != null)
                                Expanded(
                                  child: Image(
                                    image: NetworkImage(
                                        match.secondTeamLogo
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    match.secondTeam,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //-----------
                          const SizedBox(
                            height: 8,
                          ),

                          Row(
                            children:[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey),
                                    // color: Colors.amberAccent
                                  ),
                                  child: InkWell(
                                    onTap: ()async{

                                     List<Location> locations = await TazkartiUserCubit.get(context).getLatAndLngOfAddress(address: match.stadiumName);
                                     AwesomeDialog(
                                       context: context,
                                       dialogType: DialogType.NO_HEADER,
                                       animType: AnimType.BOTTOMSLIDE,
                                       title: 'Match Location',
                                       desc: 'Are you want to go and see the location of ${match.stadiumName} on google map',
                                       btnCancelOnPress: () {

                                       },
                                       btnOkOnPress: () {
                                         navigateTo(context, StadiumLocation(latitude: locations[0].latitude, longitude: locations[0].longitude));
                                       },
                                     ).show();

                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Stadium : ${match.stadiumName}',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                          fontSize: 20,
                                          color: HexColor('104B2B'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8,),
                          //  if (cubit.stadiumName != null)
                          InkWell(
                            onTap: () async {

                              List<Location> locations = await TazkartiUserCubit.get(context).getLatAndLngOfAddress(address: match.stadiumName);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.NO_HEADER,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Match Location',
                                desc: 'Are you want to go and see the location of ${match.stadiumName} on google map',
                                btnCancelOnPress: () {

                                },
                                btnOkOnPress: () {
                                  navigateTo(context, StadiumLocation(latitude: locations[0].latitude, longitude: locations[0].longitude));
                                },
                              ).show();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image(
                                image: NetworkImageWithRetry(match.stadiumUrl),
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.money, size: 30, color: HexColor('104B2B'), ),
                              SizedBox(width: 8,),
                              Expanded(
                                child: Text('Ticket Price: ${match.ticketPrice}\$',
                                  //textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  fontSize: 24,
                                    color: HexColor('104B2B'),
                                ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            height: 1,
                            width: double.infinity,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              Icon(Icons.analytics_outlined, size: 30, color: HexColor('104B2B'), ),
                              SizedBox(width: 8,),
                              Expanded(
                                child: Text('Available tickets: ${int.parse(match.matchTickets)-match.numOfReservedTickets}',
                                  //textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 24,
                                    color: HexColor('104B2B'),
                                  ),
                                ),
                              )
                            ],
                          ),

                        ],
                        ),
                    )
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Num of tickets:',
                                //textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  fontSize: 24,
                                  color: HexColor('104B2B'),
                                ),
                              ),
                              IconButton(
                                  onPressed: (){
                                    if(numOfTickets<3&& numOfTickets+1<= int.parse(match.matchTickets)-match.numOfReservedTickets) {
                                      numOfTickets++;
                                      cubit.changeTicketsNum();
                                    }
                                  },
                                  icon: const Icon(
                                      Icons.add_sharp,
                                      color: Colors.green,
                                  )
                              ),
                              Text('$numOfTickets',
                                //textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  fontSize: 24,
                                  color: HexColor('104B2B'),
                                ),
                              ),
                              IconButton(
                                  onPressed: (){
                                    if(numOfTickets>1) {
                                      numOfTickets--;
                                      cubit.changeTicketsNum();
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.red,
                                  )
                              ),

                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            height: 1,
                            width: double.infinity,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text('Total price: ${numOfTickets*int.parse(match.ticketPrice)}\$',
                                //textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  fontSize: 24,
                                  color: HexColor('104B2B'),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),

                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Conditional.single(
                    context: context,
                    conditionBuilder: (context)=> state is! TazkartiUserLoadingReserveTicketsState,
                    widgetBuilder: (context)=> defaultMaterialButton(
                        onPressed: (){
                          cubit.makeReservation(
                              matchId: match.matchId,
                              numOfTickets: numOfTickets,
                              totalPrice: (double.parse(match.ticketPrice)*numOfTickets),
                              newNumOfReservedTickets: match.numOfReservedTickets + numOfTickets
                          );
                          //-------------
                          Dialogs.bottomMaterialDialog(
                              msg: 'Tickets reserved successfully',
                              title: 'Reserve tickets',
                              context: context,
                              actions: [
                                IconsOutlineButton(
                                  onPressed: () {
                                    //Navigator.pop(context);
                                    navigateAndFinish(context, TazkartiUserLayout());
                                  },
                                  text: 'OK',
                                  iconData: Icons.done,
                                  textStyle: const TextStyle(color: Colors.white),
                                  iconColor: Colors.white,
                                  color: Colors.green,
                                ),
                              ]);
                        },
                        text: 'reserve',
                        gradientColorsList: [
                          Colors.green,
                          HexColor('104B2B'),
                        ],
                        radius: 5,
                        fontSize: 20
                    ),
                    fallbackBuilder:(context)=> const Center(child: CircularProgressIndicator(color: Colors.green,), )

                  )
                ],
              ),
            ),
          ),

        );
      },
    );
  }
}
