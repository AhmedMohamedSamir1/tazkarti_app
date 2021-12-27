abstract class TazkartiRegisterStates {}


class TazkartiRegisterInitialState extends TazkartiRegisterStates {}

class TazkartiRegisterLoadingState extends TazkartiRegisterStates {}
class TazkartiRegisterSuccessState extends TazkartiRegisterStates {
  late final String uId;
  TazkartiRegisterSuccessState(this.uId);
}
class TazkartiRegisterErrorState extends TazkartiRegisterStates {}

class TazkartiRegisterChangePassState extends TazkartiRegisterStates {}
