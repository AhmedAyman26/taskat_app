import 'package:equatable/equatable.dart';
import 'package:notes/common/network/sas.dart';

class RegisterStates extends Equatable {
  final RequestStatus? registerState;
  final String? errorMessage;

  RegisterStates(
      {this.registerState = RequestStatus.initial, this.errorMessage = ''});

  RegisterStates reduce({
    RequestStatus? registerState,
    String? errorMessage,
  })
  {
    return RegisterStates(
      registerState: registerState ?? this.registerState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [registerState, errorMessage];
}
