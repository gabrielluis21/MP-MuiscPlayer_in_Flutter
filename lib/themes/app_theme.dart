import 'package:flutter/material.dart';
import 'package:mymusicplayer/themes/my_theme.dart';

class AppTheme{
  String name;
  MyTheme theme;
  AppTheme(this.name, this.theme);
}

  List<AppTheme> myThemes = [
    AppTheme(
        'Default',
        MyTheme(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
        )),
    AppTheme(
      'Teal',
      MyTheme(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
      ),
    ),
    AppTheme(
      'Orange',
      MyTheme(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
      ),
    ),
    AppTheme(
      'Dark',
      MyTheme(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),
    ),
  ];