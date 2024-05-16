import 'package:fluchat/domain/exceptions/auth_exception.dart';
import 'package:fluchat/domain/usecases/login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/backend_logic.dart';

enum SignInState {
  none,
  existing_user,
}

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(
    this._loginUseCase,
  ) : super(SignInState.none);

  final LoginUseCase _loginUseCase;

  void signIn() async {
    try {
      final result = await _loginUseCase.validateLogin();
      if (result) {
        await BackendLogic().fetchData();
        emit(SignInState.existing_user);
      }
    } catch (ex) {
      final result = await _loginUseCase.signIn();
      if (result != null) {
        emit(SignInState.none);
      }
    }
  }
}
