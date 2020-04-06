import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/data/album.dart';
import 'package:mymusicplayer/data/music.dart';
import 'package:mymusicplayer/data/player_state.dart';
import 'package:mymusicplayer/tiles/music_tile.dart';

class SpecificAlbumScreen extends StatelessWidget {
  final Album _album;

  SpecificAlbumScreen({@required Album album}) : _album = album;

  @override
  Widget build(BuildContext context) {
    final _globalBloc = BlocProvider.getBloc<MusicPlayerBloc>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF274D85),
              size: 35,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            _album.name,
            style: TextStyle(
              color: Color(0xFF274D85),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: double.infinity,
                height: 2,
                color: Color(0xFFD9EAF1),
              ),
            ),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: StreamBuilder<List<Music>>(
          stream: _globalBloc.songs$,
          builder: ( context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final List<Music> _allSongs = snapshot.data;
            List<Music> _albumSongs = [];
            for (var song in _allSongs) {
              if (song.albumId == _album.id) {
                _albumSongs.add(song);
              }
            }

            return ListView.builder(
              key: UniqueKey(),
              padding: const EdgeInsets.only(bottom: 16.0),
              physics: BouncingScrollPhysics(),
              itemCount: _albumSongs.length,
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
                    final bool _isSelectedSong =
                        _currentSong == _albumSongs[index];
                    return GestureDetector(
                      onTap: () {
                        _globalBloc.updatePlaylist(_albumSongs);
                        switch (_state) {
                          case PlayerState.playing:
                            if (_isSelectedSong) {
                              _globalBloc.pauseMusic(_currentSong);
                            } else {
                              _globalBloc.stopMusic();
                              _globalBloc.playMusic( _albumSongs[index]);
                            }
                            break;
                          case PlayerState.paused:
                            if (_isSelectedSong) {
                              _globalBloc.playMusic(_albumSongs[index]);
                            } else {
                              _globalBloc.stopMusic();
                              _globalBloc.playMusic(_albumSongs[index]);
                            }
                            break;
                          case PlayerState.stopped:
                            _globalBloc.playMusic(_albumSongs[index]);
                            break;
                          default:
                            break;
                        }
                      },
                      child: MusicTile(
                        music: _albumSongs[index],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
