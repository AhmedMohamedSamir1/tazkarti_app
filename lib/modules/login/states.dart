abstract class TazkartiLoginStates {}


class TazkartiLoginInitialState extends TazkartiLoginStates {}

class TazkartiLoginLoadingState extends TazkartiLoginStates {}
class TazkartiLoginSuccessState extends TazkartiLoginStates {
  late final String uId;
  late final String userEmail;
  late final String authType;

  TazkartiLoginSuccessState(this.uId, this.userEmail, this.authType);
}
class TazkartiLoginErrorState extends TazkartiLoginStates {}

class TazkartiLoginChangePassState extends TazkartiLoginStates {

}
