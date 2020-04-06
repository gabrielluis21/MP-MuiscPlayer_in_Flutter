import 'package:flutter/material.dart';
import 'package:mymusicplayer/themes/app_theme.dart';
import 'package:mymusicplayer/blocs/app_theme_bloc.dart';

class SettingsScreen extends StatelessWidget {
  final AppThemeBloc bloc;

  SettingsScreen({Key key, @required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "Settings",
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                StreamBuilder<AppTheme>(
                    stream: bloc.outTheme,
                    builder: (context, snapshot) {
                      return DropdownButton<AppTheme>(
                        hint: Text("Select a theme:"),
                        value: snapshot.data,
                        items: myThemes.map((AppTheme appTheme) {
                          return DropdownMenuItem<AppTheme>(
                            value: appTheme,
                            child: Text(appTheme.name),
                          );
                        }).toList(),
                        onChanged: bloc.inTheme,
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}