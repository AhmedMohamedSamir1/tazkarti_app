
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import 'package:tazkarti_system/models/match_model.dart';
import 'package:tazkarti_system/modules/edit_match_screen/edit_match.dart';
import 'package:tazkarti_system/modules/reserve_match/reserve_match_screen.dart';
import 'package:tazkarti_system/modules/user_layout/cubit.dart';
import 'package:tazkarti_system/modules/user_layout/states.dart';
import 'package:tazkarti_system/shared/components/components.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TazkartiUserCubit, TazkartiUserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TazkartiUserCubit.get(context);
        return Scaffold(
            body: Conditional.single(
                context: context,
                conditionBuilder: (context) => cubit.matches.length != 0,
                widgetBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => buildItem(context, cubit.matches[index]),
                        separatorBuilder: (context, index) => const SizedBox(height: 8,),
                        itemCount: cubit.matches.length
                    )
                ),
                fallbackBuilder: (context) => Center(
                  child: LoadingBouncingLine.square(
                    borderColor: Colors.green,
                    backgroundColor: Colors.green,
                    borderSize: 3.0,
                    size: 200.0,
                    duration: const Duration(milliseconds: 800),
                  ),
                )
            )
        );
      },
    );
  }
}




Widget buildItem(context, MatchModel match,) {
  return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(match.matchDate,
                      textAlign: TextAlign.center,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    match.firstTeam,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Image(
                    image: NetworkImage(match.firstTeamLogo),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        match.matchTime,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 30,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            foregroundColor:
                            MaterialStateProperty.all(Colors.blue),
                          ),
                          child: const Text('Reserve'),
                          onPressed: () async {
                            bool isUserReserveBefore = await TazkartiUserCubit.get(context).isReserve(matchId: match.matchId);
                            if(isUserReserveBefore){
                              StylishDialog(
                                context: context,
                                alertType: StylishDialogType.INFO,
                                titleText: 'Reserve Tickets',
                                contentText: 'you reserved tickets for this match before',
                                confirmButton: MaterialButton(
                                  child: Text(
                                    'OK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.green,
                                ),
                              ).show();
                            }
                            else if( int.parse(match.matchTickets) - match.numOfReservedTickets>0) {
                              navigateTo(context, ReserveMatchScreen(match: match));
                            }
                            else{
                              StylishDialog(
                                context: context,
                                alertType: StylishDialogType.INFO,
                                titleText: 'Reserve Tickets',
                                contentText: 'Unfortunately all tickets are reserved',
                                confirmButton: MaterialButton(
                                  child: Text(
                                    'OK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.green,
                                ),
                              ).show();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),

                Expanded(
                  child: Image(
                    image: NetworkImage(match.secondTeamLogo),
                  ),
                ),
                Expanded(
                  child: Text(
                    match.secondTeam,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
}
