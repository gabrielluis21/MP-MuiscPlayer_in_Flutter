import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/blocs/search_bloc.dart';
import 'package:mymusicplayer/data/music.dart';
import 'package:mymusicplayer/data/player_state.dart';
import 'package:mymusicplayer/tiles/music_tile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _globalBloc = BlocProvider.getBloc<MusicPlayerBloc>();
    final _searchBloc = BlocProvider.getBloc<SearchBloc>();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF274D85),
              size: 35,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: StreamBuilder<List<Music>>(
            stream: _globalBloc.songs$,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final List<Music> _songs = snapshot.data;
              return TextField(
                controller: _textEditingController,
                cursorColor: Color(0xFF274D85),
                decoration: InputDecoration(
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFD9EAF1).withOpacity(0.7),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFD9EAF1).withOpacity(0.7),
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Color(0xFF274D85),
                  fontSize: 22.0,
                ),
                autofocus: true,
                onChanged: (String value) {
                  _searchBloc.updateFilteredSongs(value, _songs);
                },
              );
            },
          ),
        ),
        body: StreamBuilder<List<Music>>(
          stream: _searchBloc.filteredSongs$,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final List<Music> _filteredSongs = snapshot.data;

            if (_filteredSongs.length == 0) {
              return Center(
                child: Text(
                  "Enter proper keywords to start searching",
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Color(0xFF274D85),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListView.builder(
              key: UniqueKey(),
              padding: const EdgeInsets.only(bottom: 30.0),
              physics: BouncingScrollPhysics(),
              itemCount: _filteredSongs.length,
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
                        _currentSong == _filteredSongs[index];
                    return GestureDetector(
                      onTap: () {
                        _globalBloc.updatePlaylist(_filteredSongs);
                        switch (_state) {
                          case PlayerState.playing:
                            if (_isSelectedSong) {
                              _globalBloc.pauseMusic(_currentSong);
                            } else {
                              _globalBloc.stopMusic();
                              _globalBloc.playMusic(
                                _filteredSongs[index],
                              );
                            }
                            break;
                          case PlayerState.paused:
                            if (_isSelectedSong) {
                              _globalBloc.playMusic(_filteredSongs[index]);
                            } else {
                              _globalBloc.stopMusic();
                              _globalBloc.playMusic(
                                _filteredSongs[index],
                              );
                            }
                            break;
                          case PlayerState.stopped:
                            _globalBloc.playMusic(_filteredSongs[index]);
                            break;
                          default:
                            break;
                        }
                      },
                      child: MusicTile(
                        music: _filteredSongs[index],
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
