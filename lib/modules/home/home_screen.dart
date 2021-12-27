import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:stylish_dialog/stylish_dialog.dart';
import 'package:tazkarti_system/models/match_model.dart';
import 'package:tazkarti_system/modules/admin_layout/cubit.dart';
import 'package:tazkarti_system/modules/admin_layout/states.dart';
import 'package:tazkarti_system/modules/edit_match_screen/edit_match.dart';
import 'package:tazkarti_system/shared/components/components.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatelessWidget {

  var searchController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {


    return BlocConsumer<TazkartiAdminCubit, TazkartiAdminStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TazkartiAdminCubit.get(context);
        return Scaffold(
            key: scaffoldKey,
            body: Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    cubit.matches.length != 0 &&
                    cubit.teamsData.length != 0 &&
                    cubit.teamsData.length != 0,
                widgetBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        if (cubit.searchTextFormField)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: TextFormField(
                                      controller: searchController,
                                      keyboardType:TextInputType.text,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter a team',
                                        prefixIcon: Icon(Icons.search,)
                                      ),
                                      onChanged: (String value){
                                        if(value!=''){
                                          cubit.getTeamMatches(value);
                                        }
                                        else{
                                          cubit.displayedMatches = cubit.matches;
                                          cubit.selectedDateChanged();
                                        }
                                      },

                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 50,
                                      child: PopupMenuButton(
                                        icon: const Icon(Icons.menu, color: Colors.white,),
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            const PopupMenuItem(
                                              value: 'Not Published',
                                              child: ListTile(
                                                title: Text('Not Published Matches'),
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'Published',
                                              child: ListTile(
                                                title: Text('Published Matches'),
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'Future Matches',
                                              child: ListTile(
                                                title: Text('Future Matches'),
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'Past Matches',
                                              child: ListTile(
                                                title: Text('Past Matches'),
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'Today Matches',
                                              child: ListTile(
                                                title: Text('Today Matches'),
                                              ),
                                            ),
                                            const PopupMenuItem(

                                              value: 'All Matches',
                                              child: ListTile(
                                                title: Text('All Matches'),
                                              ),
                                            ),
                                          ];
                                        },
                                       onSelected: (String val){
                                          if(val=='Not Published'){
                                            cubit.getNotPublishedMatches();
                                          }
                                          else if(val=='Published'){
                                            cubit.getPublishedMatches();
                                          }
                                          else if(val=='Future Matches'){
                                            cubit.getFutureMatches();
                                          }
                                          else if(val=='Past Matches'){
                                            cubit.getPastMatches();
                                          }
                                          else if(val=='Today Matches'){
                                            cubit.geTodayMatches();
                                          }
                                          else{
                                            cubit.displayedMatches = cubit.matches;
                                            cubit.selectedDateChanged();
                                          }

                                       },
                                      ),
                                      color: Colors.green,
                                    ),
                                  )

                                ],
                              ),
                            ),
                          ),
                        
                        Expanded(
                          child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) => buildItem(
                                  context, cubit.displayedMatches[index], state, index),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 8,
                                  ),
                              itemCount: cubit.displayedMatches.length),
                        ),
                      ],
                    )),
                fallbackBuilder: (context) => Center(
                      child: LoadingBouncingLine.square(
                        borderColor: Colors.green,
                        backgroundColor: Colors.green,
                        borderSize: 3.0,
                        size: 200.0,
                        duration: const Duration(milliseconds: 800),
                      ),
                    )));
      },
    );
  }

  Widget buildItem(context, MatchModel match, state, int index) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.zero,
      child: Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),
          extentRatio: 0.3, // the size of Slidable Action

          // dismissible: DismissiblePane(onDismissed: () {}),

          children: [
            Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    state is! TazkartiAdminLoadingDeleteMatchesState,
                widgetBuilder: (context) => SlidableAction(
                      onPressed: (context) {
                        if (!match.ticketsPublished) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.NO_HEADER,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Delete Match',
                            desc:
                                'Are you sure that you want to delete (${match.firstTeam} & ${match.secondTeam}) match',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                                TazkartiAdminCubit.get(context).matches.removeAt(index);
                                TazkartiAdminCubit.get(context).deleteMatch(matchID: match.matchId);

                              //--------------------
                              Dialogs.bottomMaterialDialog(
                                  msg: 'Match Deleted Successfully',
                                  title: 'Delete Match',
                                  context: context,
                                  actions: [
                                    IconsButton(
                                      onPressed: () {

                                        Navigator.pop(scaffoldKey.currentContext!);
                                      },
                                      text: 'OK',
                                      color: Colors.red,
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ]);
                            },
                          ).show();
                        } else {
                          StylishDialog(
                            context: context,
                            alertType: StylishDialogType.ERROR,
                            titleText: 'Delete Tickets',
                            contentText:
                                'Tickets is already published so delete not available',
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
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                      autoClose: false,
                    ),
                fallbackBuilder: (context) => const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CircularProgressIndicator(),
                    ))
          ],
        ),
        endActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),
          extentRatio: 0.3, // the size of Slidable Action

          // dismissible: DismissiblePane(onDismissed: () {}),

          children: [
            Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    state is! TazkartiAdminLoadingDeleteMatchesState,
                widgetBuilder: (context) => SlidableAction(
                      onPressed: (context) {
                        BuildContext homeContext = context;
                        if (!match.ticketsPublished) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.INFO,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Publish Tickets',
                            desc:
                                'Are you sure that you want to publish (${match.firstTeam} & ${match.secondTeam}) tickets',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.WARNING,
                                animType: AnimType.BOTTOMSLIDE,
                                title: 'Publish Tickets',
                                desc:
                                    'once you publish match tickets you can\'t edit this match \n are you want to continue',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {
                                  context = context;

                                  match.ticketsPublished = true;
                                  TazkartiAdminCubit.get(context)
                                      .sendEmailInformingUsersWithTickets(
                                    emailSubject: 'Tazkarti - Tickets Publishing',
                                    emailBody:
                                        'Good news [Tickets for] ${match.firstTeam} & ${match.secondTeam} are available now \n'
                                        'hurry up to get a ticket before stocks run out',
                                  ).then((value) {
                                    TazkartiAdminCubit.get(context).releaseMatchTickets(matchId: match.matchId);
                                  });
                                },
                              ).show();
                            },
                          ).show();
                        } else {
                          StylishDialog(
                            context: context,
                            alertType: StylishDialogType.INFO,
                            titleText: 'Publish Tickets',
                            contentText: 'Tickets is already published',
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
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.publish,
                      label: 'Publish',
                      autoClose: false,
                    ),
                fallbackBuilder: (context) => const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CircularProgressIndicator(),
                    ))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(match.matchDate,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1),
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
                      style: Theme.of(context)
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        match.matchTime,
                        style: Theme.of(context)
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
                          child: const Text('Edit'),
                          onPressed: () {
                            if (!match.ticketsPublished) {
                              navigateTo(
                                  context, EditMatchScreen(match: match));
                            } else {
                              StylishDialog(
                                context: context,
                                alertType: StylishDialogType.ERROR,
                                titleText: 'Publish Tickets',
                                contentText:
                                    'Tickets is already published so edit not available',
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
                  Expanded(
                    child: Image(
                      image: NetworkImage(match.secondTeamLogo),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      match.secondTeam,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
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
      ),
    );
  }
}


