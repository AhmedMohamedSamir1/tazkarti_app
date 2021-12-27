import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:tazkarti_system/models/match_model.dart';
import 'package:tazkarti_system/modules/add_matches/add_matches_screen.dart';
import 'package:tazkarti_system/modules/admin_layout/states.dart';
import 'package:tazkarti_system/modules/home/home_screen.dart';
import 'package:tazkarti_system/modules/settings/user_reserved_matches_screen.dart';
import 'package:tazkarti_system/shared/components/basics.dart';
import 'package:tazkarti_system/shared/components/components.dart';
import 'package:tazkarti_system/shared/network/firebase_class.dart';
import 'package:tazkarti_system/shared/styles/icon_broken.dart';

class TazkartiAdminCubit extends Cubit<TazkartiAdminStates> {

  TazkartiAdminCubit() : super(TazkartiAdminInitialState());

  //to be more easily when use this cubit in many places
  static TazkartiAdminCubit get(context) => BlocProvider.of(context);


  //---------start bottom nav bar--------------


  List<Widget> bottomItems =
  [
    const Icon(
      IconBroken.Home,
      size: 20,
    ),
    const Icon(
      Icons.my_library_add_sharp,
      size: 20,
    ),
  ];

  List<Widget> screens =
  [
     HomeScreen(),
    AddMatchesScreen(),
  ];

  List<String> titles =
  [
    'All Matches',
    'Add Matches',
  ];

  int currentIndex = 0;

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(TazkartiAdminChangeBtnNavState());
  }


  List<BottomNavigationBarItem> bottomNavBarItems = const[
    BottomNavigationBarItem(
        icon: Icon(IconBroken.Home),
        label: "Home"
    ),
    BottomNavigationBarItem(
        icon: Icon(IconBroken.Chat),
        label: "Chat"
    ),
    BottomNavigationBarItem(
        icon: Icon(IconBroken.Paper_Upload),
        label: "Post"
    ),
    BottomNavigationBarItem(
        icon: Icon(IconBroken.Location),
        label: "Users"
    ),
    BottomNavigationBarItem(
        icon: Icon(IconBroken.Setting),
        label: "Settings"
    ),
  ];

  //---------end bottom nav bar--------------

//--------- start readTeamsFile ----------------------
  Map<String, String> teamsData = {};

  void readTeamsFile() async
  {

    emit(TazkartiAdminLoadingFilesState());
    List<String> allFiles = await readTextFile(txtFileName: 'teams.txt');

    for (int i = 1; i < allFiles.length - 1; i++) {
      List<String> teamLine = allFiles[i].split('\t');
      teamsData.addAll({teamLine[0]: teamLine[1]});
    }
    // print(teamsData['90']);
    emit(TazkartiAdminSuccessLoadingFilesState());
  }

  //-----------end readTeamsFile---------------

  //--------- start readTeamsFile ----------------------
  Map<String, String> stadiumsData = {};

  void readStadiumsFile() async
  {
    List<String> allFile = await readTextFile(txtFileName: 'stadiums.txt');

    for (int i = 0; i < allFile.length - 1; i++) {
      List<String> stadiumLine = allFile[i].split('\t');
      stadiumsData.addAll({stadiumLine[0]: stadiumLine[1].substring(0, stadiumLine[1].length-1)});
      // substring is used because the last char is ' '
    }
    emit(TazkartiAdminSuccessLoadingFilesState());

  }

//-----------end readTeamsFile---------------

//--------------------

  String? firstTeamName;
  String? secondTeamName;
  String? stadiumName;

//---------------------

  void selectedTeamChanged() {
    emit(TazkartiAdminSelectedTeamChangedState());
  }

  void selectedDateChanged() {
    emit(TazkartiAdminSelectedTeamChangedState());
  }

  void selectedStadiumChanged() {
    emit(TazkartiAdminSelectedStadiumChangedState());
  }

  //----------start add match------
  void addMatch({
    required String firstTeam,
    required String firstTeamLogo,
    required String secondTeam,
    required String secondTeamLogo,
    required String matchDate,
    required String matchTime,

    required String stadiumName,
    required String stadiumUrl,
    required String matchTickets,
    required String ticketPrice,
  }) {

    emit(TazkartiAdminLoadingAddMatchesState());
    String matchId = FirebaseFirestore.instance.collection('match').doc().id;

    DateTime date =  DateFormat('MMM dd, yyyy HH:mm a').parse('$matchDate $matchTime');

   MatchModel match =  MatchModel(
      date: date,
      matchId: matchId,
      matchDate: matchDate,
      matchTime: matchTime,
      firstTeam: firstTeam,
      firstTeamLogo: firstTeamLogo,
      secondTeam: secondTeam,
      secondTeamLogo: secondTeamLogo,
      stadiumName: stadiumName,
      stadiumUrl: stadiumUrl,
      matchTickets: matchTickets,
      ticketPrice: ticketPrice,
     ticketsPublished: false,
     numOfReservedTickets: 0,
   );

    FireBaseClass.addToFireSore(collectionName: 'match', docName: matchId, model: match.toMap())
        .then((value) {
          toastMessage(textMessage: 'Match added successfully', toastState: ToastStates.SUCCESS);
      emit(TazkartiAdminSuccessAddMatchesState());
    }).catchError((onError){
      toastMessage(textMessage: onError.toString(), toastState: ToastStates.SUCCESS);
      emit(TazkartiAdminErrorAddMatchesState());
    });
  }
//----------end add match--------

//----------start loading all matches ---------

  List<MatchModel>matches = [];
  List<MatchModel>displayedMatches = [];

  void getAllMatches()
  {

    emit(TazkartiAdminLoadingGetMatchesState());
    FirebaseFirestore.instance
        .collection('match')
        .orderBy('date',descending: false)
        .snapshots()
        .listen( (event) {
          matches = [];
       for (var element in event.docs) {
           matches.add(MatchModel.fromJson(element.data()));
       }
       emit(TazkartiAdminSuccessGetMatchesState());
       displayedMatches = matches;
    });

  }
//----------end loading all matches --------



//----------start update Match--------

void updateMatch({
    required MatchModel match,
  })
{
  emit(TazkartiAdminLoadingAddMatchesState());

    FireBaseClass.updateFireSoreData(
        collectionName: 'match',
        docName: match.matchId,
        model: match.toMap()
    ).then((value) {
      emit(TazkartiAdminLoadingAddMatchesState());
      toastMessage(textMessage: 'Match updated successfully', toastState: ToastStates.SUCCESS);
    }).catchError((onError){
      emit(TazkartiAdminLoadingAddMatchesState());

    });
}

//---------- end update Match---------

//----------start delete match---------
void deleteMatch({required String matchID})
{
  emit(TazkartiAdminLoadingDeleteMatchesState());

  FirebaseFirestore.instance.collection('match').doc(matchID).delete().
  then((value) {
    emit(TazkartiAdminSuccessDeleteMatchesState());
    // toastMessage(textMessage: 'Match deleted successfully', toastState: ToastStates.SUCCESS);
  }).catchError((onError){
    emit(TazkartiAdminErrorDeleteMatchesState());

  });
}
//----------end delete match---------


//---------- start release match tickets ---------

  void releaseMatchTickets({
    required String matchId,
  })
  {
    emit(TazkartiAdminLoadingReleaseMatchTicketsState());

    FireBaseClass.updateFireSoreData(
        collectionName: 'match',
        docName: matchId,
        model: {'ticketsPublished':true}
    ).then((value) {
      emit(TazkartiAdminSuccessReleaseMatchTicketsState());
    }).catchError((onError){
      emit(TazkartiAdminErrorReleaseMatchTicketsState());

    });
  }
  //---------- end release match tickets ---------

  //------------Start Sending email to all users informing them with new ---------------------
  Future<void> sendEmailInformingUsersWithTickets({
    required String emailSubject,
    required String emailBody,

  })
  async {

    List<String> recipients=[];
    FireBaseClass.getCollectionDocsFromFireStore(collectionName: 'user').then((value)   async {
      for(var element in value.docs){
        recipients.add(element.data()['email']);
      }
      print('--------==========>'+ recipients.toString());
      final Email email = Email(
        subject: emailSubject,
        body: emailBody,
        recipients: recipients,

        isHTML: false,
      );
      await FlutterEmailSender.send(email);

    });
  }
  //------------ End Sending email to all users informing them with new -------

  //------ search text form field appear and disappear------------------
  bool searchTextFormField = false;
  void showSearchTextFormField(){
    searchTextFormField = !searchTextFormField;
    emit(TazkartiAdminSelectedDateChangedState());
  }
  //------ search text form field appear and disappear------------------


  //------start get not published matches-------

  List<MatchModel> notPublishedMatches = [];
  void getNotPublishedMatches(){
    notPublishedMatches = [];
    for(int i = 0 ; i< matches.length ; i++){
      if(matches[i].ticketsPublished==false) {
        notPublishedMatches.add(matches[i]);
      }
    }
    displayedMatches = notPublishedMatches;
    emit(TazkartiAdminSelectSearchOptionState());
  }
  //------end get not published matches---------

  //------start get published matches-------

  List<MatchModel> publishedMatches = [];
  void getPublishedMatches(){
    publishedMatches = [];
    for(int i = 0 ; i< matches.length ; i++){
      if(matches[i].ticketsPublished==true) {
        publishedMatches.add(matches[i]);
      }
    }
    displayedMatches = publishedMatches;
    emit(TazkartiAdminSelectSearchOptionState());
  }
  //------end get published matches---------

  //------start get future matches-------
  List<MatchModel> futureMatches = [];
  void getFutureMatches(){

    futureMatches = [];

    DateTime date1 =  DateTime.now(); // 2021-10-22 01:30:24.670
    date1 =  DateFormat('yyyy-MM-dd').parse(date1.toString());
   // date = date.add(const Duration(days: 1));
    for(int i =0 ; i<matches.length;i++) {
      DateTime date2 =  DateFormat('MMM dd, yyyy').parse(matches[i].matchDate);
      date2 =  DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').format(date2));
      if(date2.isAfter(date1)){
        futureMatches.add(matches[i]);
      }
    }
    displayedMatches = futureMatches;
    emit(TazkartiAdminSelectSearchOptionState());
  }
  //------end get future matches---------

  //------start get past matches-------
  List<MatchModel> pastMatches = [];
  void getPastMatches(){

    pastMatches = [];

    DateTime date1 =  DateTime.now(); // 2021-10-22 01:30:24.670
    date1 =  DateFormat('yyyy-MM-dd').parse(date1.toString());
    // date = date.add(const Duration(days: 1));
    for(int i =0 ; i<matches.length;i++) {
      DateTime date2 =  DateFormat('MMM dd, yyyy').parse(matches[i].matchDate);
      date2 =  DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').format(date2));
      if(date2.isBefore(date1)){
        pastMatches.add(matches[i]);
      }
    }
    displayedMatches = pastMatches;
    emit(TazkartiAdminSelectSearchOptionState());
  }
  //------end get past matches---------

  //------start get today matches-------
  List<MatchModel> todayMatches = [];
  void geTodayMatches(){
    todayMatches = [];

    DateTime date1 =  DateTime.now(); // 2021-10-22 01:30:24.670
    date1 =  DateFormat('yyyy-MM-dd').parse(date1.toString());
    for(int i =0 ; i<matches.length;i++) {
      DateTime date2 =  DateFormat('MMM dd, yyyy').parse(matches[i].matchDate);
      date2 =  DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').format(date2));
      if(date2 == date1){
        todayMatches.add(matches[i]);
      }
    }
    displayedMatches = todayMatches;
    emit(TazkartiAdminSelectSearchOptionState());
  }
  //------end get future matches---------

  //------start search by team-------
  List<MatchModel> teamMatches = [];
  void getTeamMatches(String val){
    teamMatches = [];
    String searchName = val.toLowerCase();
    for(int i =0 ; i<matches.length;i++) {
      if(matches[i].firstTeam.toLowerCase().contains(searchName)||matches[i].secondTeam.toLowerCase().contains(searchName)){
        teamMatches.add(matches[i]);
      }
    }
    displayedMatches = teamMatches;
    emit(TazkartiAdminSelectSearchOptionState());
  }
//------end search by team-----------
}