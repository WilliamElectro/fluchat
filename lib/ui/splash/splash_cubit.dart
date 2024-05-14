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
      //TODO: conectar servicios de back
      //GlobalVariables.tokenBackend = (await ApiServiceBack().loginBackEnd(GlobalVariables.googleUser!.email)) as String?;
      //final List<dynamic> data = await ApiServiceBack().fetchNovelties();
      if (result) {
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
}
