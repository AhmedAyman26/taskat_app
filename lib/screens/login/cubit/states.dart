abstract class TodoLoginStates{}

class TodoLoginInitialState extends TodoLoginStates{}

class TodoLoginLoadingState extends TodoLoginStates{}

class TodoLoginSuccesState extends TodoLoginStates{
}

class TodoLoginErrorState extends TodoLoginStates{
  final String error;
  TodoLoginErrorState(this.error);
}
class TodoChangePasswordVisibilityState extends TodoLoginStates{}
