import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/data/music.dart';
import 'package:mymusicplayer/data/player_state.dart';
import 'package:mymusicplayer/utils/music_icons.dart';
import 'package:mymusicplayer/widgets/album_art.dart';
import 'package:mymusicplayer/widgets/empty_album_art.dart';
import 'package:mymusicplayer/widgets/now_playing_slider.dart';
import 'package:mymusicplayer/widgets/player_controls.dart';
import 'package:mymusicplayer/widgets/preferences_borad.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class NowPlaying extends StatelessWidget {
  final PanelController _controller;

  NowPlaying({@required PanelController controller})
      : _controller = controller;

  @override
  Widget build(BuildContext context) {
    final _globalBloc = BlocProvider.getBloc<MusicPlayerBloc>();
    final double _radius = 25.0;
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _albumArtSize = _screenHeight / 2.1;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: _albumArtSize + 50,
            child: Stack(
              children: <Widget>[
                StreamBuilder<MapEntry<PlayerState, Music>>(
                  stream: _globalBloc.playerState$,
                  builder: ( context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data.value.albumArtNetwork == null) {
                      return EmptyAlbumArtContainer(
                        radius: _radius,
                        albumArtSize: _albumArtSize,
                        iconSize: _albumArtSize / 2,
                      );
                    }

                    final Music _currentSong = snapshot.data.value;
                    return AlbumArtContainer(
                      radius: _radius,
                      albumArtSize: _albumArtSize,
                      currentSong: _currentSong,
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: PlayerControls(),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.transparent,
            height: 15,
          ),
          PreferencesBoard(),
          Divider(
            color: Colors.transparent,
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 12,
                  child: Container(
                    child: StreamBuilder<MapEntry<PlayerState, Music>>(
                      stream: _globalBloc.playerState$,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        if (snapshot.data.key == PlayerState.stopped) {
                          return Container();
                        }
                        final Music _currentSong = snapshot.data.value;

                        final String _artists = _currentSong.artist
                            .split(";")
                            .reduce((String a, String b) {
                          return a + " & " + b;
                        });
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _currentSong.album.toUpperCase() +
                                  " • " +
                                  _artists.toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFADB9CD),
                                letterSpacing: 1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Divider(
                              height: 5,
                              color: Colors.transparent,
                            ),
                            Text(
                              _currentSong.title,
                              style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF4D6B9C),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => _controller.close(),
                    child: HideIcon(
                      color: Color(0xFF90A4D4),
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.transparent,
            height: _screenHeight / 22,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: StreamBuilder<MapEntry<PlayerState, Music>>(
                        stream: _globalBloc.playerState$,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text(
                              "0:00",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFADB9CD),
                                letterSpacing: 1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          final Music _currentSong = snapshot.data.value;
                          final PlayerState _state = snapshot.data.key;
                          if (_state == PlayerState.stopped) {
                            return Text(
                              "0:00",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFADB9CD),
                                letterSpacing: 1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          return Text(
                            getDuration(_currentSong),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFADB9CD),
                              letterSpacing: 1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        }),
                  ),
                ),
                NowPlayingSlider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getDuration(Music _song) {
    final double _temp = _song.duration / 1000;
    final int _minutes = (_temp / 60).floor();
    final int _seconds = (((_temp / 60) - _minutes) * 60).round();
    if (_seconds.toString().length != 1) {
      return _minutes.toString() + ":" + _seconds.toString();
    } else {
      return _minutes.toString() + ":0" + _seconds.toString();
    }
  }
}
