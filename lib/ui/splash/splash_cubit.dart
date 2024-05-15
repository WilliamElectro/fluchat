import 'package:fluchat/GlobalVariables.dart';
import 'package:fluchat/domain/exceptions/auth_exception.dart';
import 'package:fluchat/domain/usecases/login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ApiService_web.dart';

enum SplashState {
  none,
  existing_user,
  new_user,
}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(
    this._loginUseCase,
  ) : super(SplashState.none);

  final LoginUseCase _loginUseCase;

  void init() async {
    try {
      final result = await _loginUseCase.validateLogin();
      if (result) {
        //await _fetchData();
        emit(SplashState.existing_user);
      }
    } on AuthException catch (ex) {
      if (ex.error == AuthErrorCode.not_auth) {
        emit(SplashState.none);
      } else {
        emit(SplashState.new_user);
      }
    }
  }

  /**
   * Metodo encargado de obtener los datos iniciales de servicios
   */
  Future<void> _fetchData() async {
    try {
      String token = await ApiServiceBack().loginBackEnd(GlobalVariables.googleUser!.email);
      GlobalVariables.tokenBackend = token;

    } catch (error) {
      print('Error al obtener información: $error');
    }
  }
}
