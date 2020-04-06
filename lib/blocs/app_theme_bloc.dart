import 'package:rxdart/rxdart.dart';
import 'package:mymusicplayer/themes/app_theme.dart';

class AppThemeBloc{
  final _theme = BehaviorSubject<AppTheme>();
  Function(AppTheme) get inTheme => _theme.sink.add;
  Stream<AppTheme> get outTheme => _theme.stream;

  AppThemeBloc() {
    print('‘ — — — -APP BLOC INIT — — — — ‘');
  }
  dispose() {
    print('‘ — — — — -APP BLOC DISPOSE — — — — — -’');
    _theme.close();
  }
}