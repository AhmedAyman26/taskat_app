
abstract class TodoRegisterStates{}

class TodoRegisterInitialState extends TodoRegisterStates{}

class TodoRegisterLoadingState extends TodoRegisterStates{}

class TodoRegisterSuccesState extends TodoRegisterStates{

}

class TodoRegisterErrorState extends TodoRegisterStates{
  final String error;
  TodoRegisterErrorState(this.error);
}
class TodoRegisterChangePasswordVisibilityState extends TodoRegisterStates{}
