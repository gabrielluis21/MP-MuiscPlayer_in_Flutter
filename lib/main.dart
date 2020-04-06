import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/blocs/search_bloc.dart';
import 'package:mymusicplayer/blocs/sound_cloud_bloc.dart';
import 'package:mymusicplayer/blocs/spotify_bloc.dart';
import 'package:mymusicplayer/screens/login_screen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => MusicPlayerBloc()),
        Bloc((i) => SearchBloc()),
        Bloc((i) => SoundCloudBloc()),
        Bloc((i) => SpotifyBloc())
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
              home: LoginScreen());
        },
      ),
      );
  }
}