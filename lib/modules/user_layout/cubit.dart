import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:tazkarti_system/models/match_model.dart';
import 'package:tazkarti_system/models/reservation_model.dart';
import 'package:tazkarti_system/modules/settings/user_reserved_matches_screen.dart';
import 'package:tazkarti_system/modules/user_home/user_home_screen.dart';
import 'package:tazkarti_system/modules/user_layout/states.dart';
import 'package:tazkarti_system/shared/components/basics.dart';
import 'package:tazkarti_system/shared/components/components.dart';
import 'package:tazkarti_system/shared/components/constants.dart';
import 'package:tazkarti_system/shared/network/firebase_class.dart';
import 'package:tazkarti_system/shared/styles/icon_broken.dart';

class TazkartiUserCubit extends Cubit<TazkartiUserStates> {

  TazkartiUserCubit() : super(TazkartiUserInitialState());

  //to be more easily when use this cubit in many places
  static TazkartiUserCubit get(context) => BlocProvider.of(context);


  //---------start bottom nav bar--------------

  List<Widget> bottomItems =
  [
    const Icon(
      IconBroken.Home,
      size: 20,
    ),
    const Icon(
      IconBroken.Profile,
      size: 20,
    ),
  ];

  List<Widget> screens =
  [
    const UserHomeScreen(),
    const ReservedMatchesScreen(),
  ];

  List<String> titles =
  [
    'Available Matches',
    'Reserved Matches',
  ];

  int currentIndex = 0;
  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(TazkartiUserChangeBtnNavState());
  }

  //---------end bottom nav bar--------------


//----------start loading all future published matches ---------
  List<MatchModel>matches = [];
  void getAllMatches() {

    emit(TazkartiUserLoadingGetMatchesState());
    FirebaseFirestore.instance
        .collection('match')
        .orderBy('date', descending: false)
        .where('date',isGreaterThan: DateTime.now())
        .where('ticketsPublished',isEqualTo: true).snapshots().listen((event) {
          matches = [];
          for (var element in event.docs) {
            matches.add(MatchModel.fromJson(element.data()));
          }
            emit(TazkartiUserSuccessGetMatchesState());
    });
  }
//----------end loading all future published matches ---------

  void changeTicketsNum() {
    emit(TazkartiUserLChangeTicketsNumberState());
  }

  //--- start make match reservation----
  void makeReservation({

    required String matchId,
    required int numOfTickets,
    required double totalPrice,
    required int newNumOfReservedTickets,
  })
  {
    emit(TazkartiUserLoadingReserveTicketsState());
    ReservationModel reservationModel = ReservationModel(userId: uId!, matchId: matchId, numOfTickets: numOfTickets, totalPrice: totalPrice);
    FirebaseFirestore.instance
        .collection('reservation')
        .doc(uId)
        .collection('matches')
        .doc(matchId)
        .set(reservationModel.toMap()).then((value) {

          FirebaseFirestore.instance
              .collection('match')
              .doc(matchId)
              .update({'numOfReservedTickets':newNumOfReservedTickets}).then((value) {
            emit(TazkartiUserSuccessReserveTicketsState());
           // toastMessage(textMessage: 'tickets reserved successfully', toastState: ToastStates.SUCCESS);
          }).catchError((onError){
            emit(TazkartiUserErrorReserveTicketsState());
            toastMessage(textMessage: onError.toString(), toastState: ToastStates.ERROR);
          });

    }).catchError((onError){
      emit(TazkartiUserErrorReserveTicketsState());
      toastMessage(textMessage: onError.toString(), toastState: ToastStates.ERROR);
    });
  }
  //--- end make match reservation------

  //---start check if user reserved in this match before
  Future<bool> isReserve({required String matchId})async
  {
    var doc = await FirebaseFirestore.instance.collection('reservation').doc(uId).collection('matches').doc(matchId).get();
    return doc.exists;
  }
  //---end check if user reserved in this match before

  //--------------------------------------------------
  Future<List<Location>> getLatAndLngOfAddress({required String address}) async {
     List<Location> locations = await locationFromAddress(address);

     print('Lat--------------> '+locations[0].latitude.toString());
     print('lng--------------> '+locations[0].longitude.toString());
     return locations;
  }
  //-------------------------------------------------

  //------start get all user reservation---------
  List<ReservationModel> userReservation = [];
  void getUserReservation(){
    FirebaseFirestore.instance
        .collection('reservation')
        .doc(uId)
        .collection('matches')
        .snapshots()
        .listen((event) {
          userReservation = [];
          for(var element in event.docs){
            ReservationModel model = ReservationModel.fromJson(element.data());

            FirebaseFirestore.instance
                .collection('match')
                .doc(element.data()['matchId'])
                .get().then((value){
                  model.matchModel = MatchModel.fromJson(value.data()!);
                  userReservation.add(model);
                  emit(TazkartiUserSuccessGetReservationsState());
            }).catchError((onError){
              emit(TazkartiUserErrorGetReservationsState());
            });
          }
    });
  }
  //------end get all user reservation---------
}