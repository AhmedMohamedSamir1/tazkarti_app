abstract class TazkartiUserStates {}

class TazkartiUserInitialState extends TazkartiUserStates {}

//Bottom NavigationBar
class TazkartiUserChangeBtnNavState extends TazkartiUserStates{}


//Home (loading matches)
class TazkartiUserLoadingGetMatchesState extends TazkartiUserStates {}
class TazkartiUserSuccessGetMatchesState extends TazkartiUserStates {}
class TazkartiUserErrorGetMatchesState extends TazkartiUserStates {}

//change tickets number
class TazkartiUserLChangeTicketsNumberState extends TazkartiUserStates {}

//reserve tickets
class TazkartiUserLoadingReserveTicketsState extends TazkartiUserStates {}
class TazkartiUserSuccessReserveTicketsState extends TazkartiUserStates {}
class TazkartiUserErrorReserveTicketsState extends TazkartiUserStates {}

//get user reservations
class TazkartiUserLoadingGetReservationsState extends TazkartiUserStates {}
class TazkartiUserSuccessGetReservationsState extends TazkartiUserStates {}
class TazkartiUserErrorGetReservationsState extends TazkartiUserStates {}