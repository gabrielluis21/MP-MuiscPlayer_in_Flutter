import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymusicplayer/animations/logo.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/blocs/search_bloc.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return BlocProvider(
      blocs: [
        Bloc((i) => MusicPlayerBloc()),
        Bloc((i) => SearchBloc()),
      ],
      child: new DynamicTheme(
        data: (brightness) => new ThemeData(
          primarySwatch: Colors.indigo,
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme){
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              home: LogoScreen());
        },
      ),
    );
  }
}