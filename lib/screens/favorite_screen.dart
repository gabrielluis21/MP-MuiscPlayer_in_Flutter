import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/data/music.dart';
import 'package:mymusicplayer/data/player_state.dart';
import 'package:mymusicplayer/tiles/music_tile.dart';
import 'package:mymusicplayer/utils/empty_screen.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _globalBloc = BlocProvider.getBloc<MusicPlayerBloc>();
    return Scaffold(
      body: StreamBuilder<List<Music>>(
        stream: _globalBloc.favorites$,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<Music> _songs = snapshot.data;
          if (_songs.length == 0) {
            return EmptyScreen(
              text: "You do not have any songs as your favorites.",
            );
          }
          return ListView.builder(
            key: PageStorageKey<String>("Favorites"),
            padding: const EdgeInsets.only(bottom: 150.0),
            physics: BouncingScrollPhysics(),
            itemCount: _songs.length,
            itemExtent: 110,
            itemBuilder: (BuildContext context, int index) {
              return StreamBuilder<MapEntry<PlayerState, Music>>(
                stream: _globalBloc.playerState$,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  final PlayerState _state = snapshot.data.key;
                  final Music _currentSong = snapshot.data.value;
                  final bool _isSelectedSong = _currentSong == _songs[index];
                  return GestureDetector(
                    onTap: () {
                      _globalBloc.updatePlaylist(_songs);
                      switch (_state) {
                        case PlayerState.playing:
                          if (_isSelectedSong) {
                            _globalBloc .pauseMusic(_currentSong);
                          } else {
                            _globalBloc.stopMusic();
                            _globalBloc.playMusic(
                              _songs[index],
                            );
                          }
                          break;
                        case PlayerState.paused:
                          if (_isSelectedSong) {
                            _globalBloc.playMusic(_songs[index]);
                          } else {
                            _globalBloc.stopMusic();
                            _globalBloc.playMusic(
                              _songs[index],
                            );
                          }
                          break;
                        case PlayerState.stopped:
                          _globalBloc.playMusic(_songs[index]);
                          break;
                        default:
                          break;
                      }
                    },
                    child: MusicTile(
                      music: _songs[index],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}