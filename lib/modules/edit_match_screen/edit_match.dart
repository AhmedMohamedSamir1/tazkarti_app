import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:tazkarti_system/models/match_model.dart';
import 'package:tazkarti_system/modules/admin_layout/cubit.dart';
import 'package:tazkarti_system/modules/admin_layout/states.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:tazkarti_system/modules/admin_layout/tazkarti_admin_layout.dart';
import 'package:tazkarti_system/shared/components/components.dart';
import 'package:tazkarti_system/shared/styles/icon_broken.dart';

class EditMatchScreen extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var DropDownKeyTeam1 = GlobalKey<DropdownSearchState<String>>();
  var DropDownKeyTeam2 = GlobalKey<DropdownSearchState<String>>();
  var DropDownKeyStadium = GlobalKey<DropdownSearchState<String>>();

  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var matchNumOfTicketsController = TextEditingController();
  var ticketPriceController = TextEditingController();

  String? key1;
  String? key2;
  String? stadiumUrl;

  MatchModel match;
  EditMatchScreen({
    Key? key,
    required this.match
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TazkartiAdminCubit, TazkartiAdminStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TazkartiAdminCubit.get(context);

        dateController.text = match.matchDate;
        timeController.text = match.matchTime;
        matchNumOfTicketsController.text = match.matchTickets;
        ticketPriceController.text = match.ticketPrice;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            centerTitle: true,
            title: Text(
              'Edit Match',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.white,
                fontSize: 20
              ),

            ),
          ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
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
                                              color: Colors.grey, fontSize: 14),
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
                           //   if (cubit.stadiumName != null)
                                Row(
                                  children:[
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Colors.grey),
                                          // color: Colors.amberAccent
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Match Stadium : ${match.stadiumName}',
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.bodyText1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                             // if (cubit.stadiumName != null)
                                const SizedBox(height: 8,),
                            //  if (cubit.stadiumName != null)
                                Container(
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      dropDownSearch(
                          dropDownList: cubit.teamsData.values.toList(),
                          hint: 'select a team',
                          dropDownSearchKey: DropDownKeyTeam1,
                          selectedItem: match.firstTeam,

                          onChanged: (String? value) {
                            match.firstTeam = value!;
                            key1 = cubit.teamsData.keys.firstWhere((k) =>
                            cubit.teamsData[k] == match.firstTeam);
                            match.firstTeamLogo = 'https://sportteamslogo.com/api?key=2fc4f5d0d1d6456e92f032135a2c544c&size=medium&tid=$key1';
                            cubit.selectedTeamChanged();
                          },
                          validator: (String? item) {
                            if (item == null) {
                              return 'team must be selected';
                            }
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      dropDownSearch(
                          dropDownList: cubit.teamsData.values.toList(),
                          hint: 'select a team',
                          dropDownSearchKey: DropDownKeyTeam2,
                          selectedItem: match.secondTeam,
                          onChanged: (String? value) {
                            match.secondTeam = value!;
                            key2 = cubit.teamsData.keys.firstWhere((k) =>
                            cubit.teamsData[k] == match.secondTeam);
                            match.secondTeamLogo = 'https://sportteamslogo.com/api?key=2fc4f5d0d1d6456e92f032135a2c544c&size=medium&tid=$key2';

                            cubit.selectedTeamChanged();
                          },
                          validator: (String? item) {
                            if (item == null) {
                              return 'team must be selected';
                            }
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      dropDownSearch(
                          dropDownList: cubit.stadiumsData.keys.toList(),
                          hint: 'select a stadium',
                          dropDownSearchKey: DropDownKeyStadium,
                          selectedItem: match.stadiumName,
                          onChanged: (String? value) {
                            match.stadiumName = value!;
                            match.stadiumUrl = cubit.stadiumsData[match.stadiumName]!;
                            cubit.selectedStadiumChanged();

                          },
                          validator: (String? item) {
                            if (item == null) {
                              return 'team must be selected';
                            }
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultTextFormField(
                        fieldController: dateController,
                        inputType: TextInputType.datetime,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "date can't be empty";
                          }
                        },
                        labelText: 'match date',
                        prefixIcon: Icons.date_range,
                        readOnly: true,

                        onTab: () {
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse("2025-12-03"))
                              .then((value) {
                                if(value!=null) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value);
                                  match.matchDate = dateController.text;
                                  cubit.selectedDateChanged();
                                }
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultTextFormField(
                        fieldController: timeController,
                        inputType: TextInputType.datetime,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "time can't be empty";
                          }
                        },
                        labelText: 'match time',
                        prefixIcon: Icons.timer,
                        readOnly: true,
                        onTab: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            if(value!=null) {
                              timeController.text = value.format(context).toString();
                              match.matchTime =timeController.text;
                              cubit.selectedDateChanged();
                            }
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultTextFormField(
                        fieldController: matchNumOfTicketsController,
                        inputType: TextInputType.datetime,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "this field can't be empty";
                          }
                        },
                        labelText: 'num of match tickets',
                        prefixIcon: Icons.sports_baseball_rounded,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultTextFormField(
                        fieldController: ticketPriceController,
                        inputType: TextInputType.number,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "ticket price can't be empty";
                          }
                        },
                        labelText: 'Ticket Price',
                        prefixIcon: Icons.money,
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Conditional.single(
                          context: context,
                          conditionBuilder: (context) =>
                          state is! TazkartiAdminLoadingUpdateMatchesState,
                          widgetBuilder: (context) => defaultMaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {

                                  match.date =  DateFormat('MMM dd, yyyy HH:mm a').parse('${dateController.text} ${timeController.text}');
                                  match.ticketPrice = ticketPriceController.text;
                                  match.matchTickets = matchNumOfTicketsController.text;

                                  cubit.updateMatch(
                                    match: match
                                  );
                                  navigateAndFinish(context, TazkartiAdminLayout());
                                }
                              },
                              text: 'edit match',
                              btnColor: Colors.green,
                              radius: 10
                          ),

                          fallbackBuilder: (context) => Container(
                            height: 20,
                            child: LoadingBouncingLine.circle(
                              borderColor: Colors.green,
                              backgroundColor: Colors.green,
                              borderSize: 3.0,
                              size: 80.0,
                              duration: const Duration(milliseconds: 1000),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
