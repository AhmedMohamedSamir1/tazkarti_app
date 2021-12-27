abstract class TazkartiAdminStates {}

class TazkartiAdminInitialState extends TazkartiAdminStates {}

//Bottom NavigationBar
class TazkartiAdminChangeBtnNavState extends TazkartiAdminStates{}


//Home (loading matches)
class TazkartiAdminLoadingGetMatchesState extends TazkartiAdminStates {}
class TazkartiAdminSuccessGetMatchesState extends TazkartiAdminStates {}
class TazkartiAdminErrorGetMatchesState extends TazkartiAdminStates {}

//selected team changed
class TazkartiAdminSelectedTeamChangedState extends TazkartiAdminStates {}
class TazkartiAdminSelectedDateChangedState extends TazkartiAdminStates {}

//selected stadium changed
class TazkartiAdminSelectedStadiumChangedState extends TazkartiAdminStates {}


// add match
class TazkartiAdminLoadingAddMatchesState extends TazkartiAdminStates {}
class TazkartiAdminSuccessAddMatchesState extends TazkartiAdminStates {}
class TazkartiAdminErrorAddMatchesState extends TazkartiAdminStates {}

// loading text files
class TazkartiAdminLoadingFilesState extends TazkartiAdminStates {}
class TazkartiAdminSuccessLoadingFilesState extends TazkartiAdminStates {}

// update match
class TazkartiAdminLoadingUpdateMatchesState extends TazkartiAdminStates {}
class TazkartiAdminSuccessUpdateMatchesState extends TazkartiAdminStates {}
class TazkartiAdminErrorUpdateMatchesState extends TazkartiAdminStates {}


// delete match
class TazkartiAdminLoadingDeleteMatchesState extends TazkartiAdminStates {}
class TazkartiAdminSuccessDeleteMatchesState extends TazkartiAdminStates {}
class TazkartiAdminErrorDeleteMatchesState extends TazkartiAdminStates {}


// release match tickets
class TazkartiAdminLoadingReleaseMatchTicketsState extends TazkartiAdminStates {}
class TazkartiAdminSuccessReleaseMatchTicketsState extends TazkartiAdminStates {}
class TazkartiAdminErrorReleaseMatchTicketsState extends TazkartiAdminStates {}

//----start select search option----

class TazkartiAdminSelectSearchOptionState extends TazkartiAdminStates {}
//---- end select search option------