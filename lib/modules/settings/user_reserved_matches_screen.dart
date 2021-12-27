import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:tazkarti_system/models/reservation_model.dart';
import 'package:tazkarti_system/modules/map/map.dart';
import 'package:tazkarti_system/modules/user_layout/cubit.dart';
import 'package:tazkarti_system/modules/user_layout/states.dart';
import 'package:tazkarti_system/shared/components/components.dart';
import 'package:geocoding/geocoding.dart';


class ReservedMatchesScreen extends StatelessWidget {
  const ReservedMatchesScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TazkartiUserCubit, TazkartiUserStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TazkartiUserCubit.get(context);
        return Scaffold(
            body: Conditional.single(
                context: context,
                conditionBuilder: (context) => cubit.userReservation.length != 0,
                widgetBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => buildItem(context, cubit.userReservation[index]),
                        separatorBuilder: (context, index) => const SizedBox(height: 8,),
                        itemCount: cubit.userReservation.length
                    )
                ),
                fallbackBuilder: (context) => Center(
                  child: Text(
                    'No data found here',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 28,
                      color: HexColor('104B2B'),
                    ),
                  ),
                )
            )
        );
      },
    );
  }

  Widget buildItem(context, ReservationModel model) {
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
                  child: Text(model.matchModel!.matchDate,
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
                    model.matchModel!.firstTeam,
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
                    image: NetworkImage(model.matchModel!.firstTeamLogo),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    model.matchModel!.matchTime,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 14),
                  ),
                ),

                Expanded(
                  child: Image(
                    image: NetworkImage(model.matchModel!.secondTeamLogo),
                  ),
                ),
                Expanded(
                  child: Text(
                    model.matchModel!.secondTeam,
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
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text('num of reserved tickets: ${model.numOfTickets}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text('total price: ${model.totalPrice} \$',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      List<Location> locations = await TazkartiUserCubit.get(context).getLatAndLngOfAddress(address: model.matchModel!.stadiumName);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.NO_HEADER,
                        animType: AnimType.BOTTOMSLIDE,
                        title: 'Match Location',
                        desc: 'Are you want to go and see the location of ${model.matchModel!.stadiumName} on google map',
                        btnCancelOnPress: () {

                        },
                        btnOkOnPress: () {
                          navigateTo(context, StadiumLocation(latitude: locations[0].latitude, longitude: locations[0].longitude));
                        },
                      ).show();
                    },
                    child: Text('Stadium: ${model.matchModel!.stadiumName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyText1!.copyWith(
                              color: HexColor('104B2B'),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
