import 'package:firebase_core/firebase_core.dart';
import 'package:fluchat/dependencies.dart';
import 'package:fluchat/firebase_options.dart';
import 'package:fluchat/ui/app_theme_cubit.dart';
import 'package:fluchat/ui/splash/splash_view.dart';
import 'package:fluchat/ui/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _streamChatClient =
      StreamChatClient('ad68nx3ettj2', logLevel: Level.INFO);

  void connectFakerUser() async {
    await _streamChatClient.disconnectUser();
    //_streamChatClient.connectUser(
     // User(id: 'wbohorquez'),
       //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYWQ2OG54M2V0dGoyIn0.ckxjypWjk2RJC7H5bit_FoMx4l9V5rqkAQOeDycCnE4',);
  }

  @override
  Widget build(BuildContext context) {
    //connectFakerUser();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    return MultiRepositoryProvider(
      providers: buildRepositories(_streamChatClient),
      child: BlocProvider(
        create: (context) => AppThemeCubit(context.read())..init(),
        child: BlocBuilder<AppThemeCubit, bool>(builder: (context, snapshot) {
          return MaterialApp(
            title: 'FluChat',
            home: SplashView(),
            theme: snapshot ? Themes.themeDark : Themes.themeLight,
            builder: (context, child) {
              return StreamChat(
                child: child,
                client: _streamChatClient,
                streamChatThemeData:
                    StreamChatThemeData.fromTheme(Theme.of(context)).copyWith(
                  ownMessageTheme: StreamMessageThemeData(
                    messageBackgroundColor:
                        Theme.of(context).colorScheme.background,
                    messageTextStyle: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
