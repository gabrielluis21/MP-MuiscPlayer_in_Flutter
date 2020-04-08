import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/widgets/bottom_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:mymusicplayer/screens/search_screen.dart';
import 'package:mymusicplayer/screens/library_screen.dart';
import 'package:mymusicplayer/screens/now_playing.dart';
import 'package:mymusicplayer/screens/album_screen.dart';
import 'package:mymusicplayer/screens/favorite_screen.dart';
import 'package:dynamic_theme/theme_switcher_widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PanelController _panelController;
  @override
  void initState(){
    _panelController = PanelController();

    super.initState();
  }

  @override
  void dispose() {
    _panelController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _radius = 25.0;
    return WillPopScope(
      onWillPop: () {
        if (!_panelController.isPanelClosed) {
          _panelController.close();
        } else {
          _showExitDialog();
        }
        return Future<bool>.value(false);
      },
      child: Scaffold(
        body: SlidingUpPanel(
          panel: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_radius),
              topRight: Radius.circular(_radius),
            ),
            child: NowPlaying(controller: _panelController),
          ),
          controller: _panelController,
          minHeight: 115,
          maxHeight: MediaQuery.of(context).size.height,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
          ),
          collapsed: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(_radius),
                topRight: Radius.circular(_radius),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.0,
                  0.7,
                ],
                colors: [
                  Color(0xFF4144FB),
                  Color(0xFF62b0f4),
                ],
              ),
            ),
            child: BottomPanel(controller: _panelController),
          ),
          body: DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  children: <Widget>[
                    Image.asset("assets/images/logo_app_music.png", height: 30, width: 30,),
                    Text(
                      "MP - Music Player",
                      style: TextStyle(
                        color: Color(0xFF274D85),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                bottom: TabBar(
                  indicatorColor: Color(0xFFD9EAF1),
                  labelColor: Color(0xFF274D85),
                  unselectedLabelColor: Color(0xFF274D85).withOpacity(0.6),
                  tabs: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "All Songs",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Albums",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Favorites",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.search,
                        color: Color(0xFF274D85),
                        size: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () {
                        showDialog(context: context,
                        builder: (context){
                          return BrightnessSwitcherDialog(
                            onSelectedTheme: (Brightness brightness) {
                              DynamicTheme.of(context).setBrightness(brightness);
                            },
                          );
                        });
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: Color(0xFF274D85),
                        size: 25,
                      ),
                    ),
                  )
                ],
                elevation: 0.0,
                backgroundColor: Colors.transparent,
              ),
              body: TabBarView(
                key: UniqueKey(),
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  LibraryScreen(),
                  AlbumScreen(),
                  FavoritesScreen(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    final _globalBloc = BlocProvider.getBloc<MusicPlayerBloc>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "MP - Musicly Player",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: Text(
            "Are you sure you want to close the app?",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Color(0xFFDF5F9D),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("NO"),
            ),
            FlatButton(
              textColor: Color(0xFFDF5F9D),
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                _globalBloc.dispose();
              },
              child: Text("YES"),
            ),
          ],
        );
      },
    );
  }
}

