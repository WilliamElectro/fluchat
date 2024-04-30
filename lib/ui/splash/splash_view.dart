import 'package:fluchat/navigator_utils.dart';
import 'package:fluchat/ui/home/home_view.dart';
import 'package:fluchat/ui/profile_verify/profile_verify_view.dart';
import 'package:fluchat/ui/sign_in/sign_in_view.dart';
import 'package:fluchat/ui/common/initial_background_view.dart';
import 'package:fluchat/ui/splash/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/**
 * Si el usuario ya esta logeado se conecta con streamChat
 */
class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(context.read())..init(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, snapshot) {
          //Pantalla de acceso
          if (snapshot == SplashState.none) {
            pushAndReplaceToPage(context, SignInView());
          } //Logeado
          else if (snapshot == SplashState.existing_user) {
            pushAndReplaceToPage(context, HomeView());
          } //Logeado pero no verificado con streamchat
          else {
            pushAndReplaceToPage(context, ProfileVerifyView());
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              InitialBackgroundView(),
              Center(
                child: Hero(
                  tag: 'logo_hero',
                  child: Image.asset(
                    'assets/Logo GCEEL.png',
                    height: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
