import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/data/music.dart';
import 'package:mymusicplayer/data/playback.dart';
import 'package:mymusicplayer/data/player_state.dart';
import 'package:rxdart/rxdart.dart';

class PreferencesBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _globalBloc = BlocProvider.getBloc<MusicPlayerBloc>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<MapEntry<MapEntry<PlayerState, Music>, List<Music>>>(
          stream: CombineLatestStream.combine2(
            _globalBloc.playerState$,
            _globalBloc.favorites$,
                (a, b) => MapEntry(a, b),
          ),
          builder: ( context, snapshot) {
            if (!snapshot.hasData) {
              return Icon(
                Icons.favorite,
                size: 35,
                color: Color(0xFFC7D2E3),
              );
            }
            final PlayerState _state = snapshot.data.key.key;
            if (_state == PlayerState.stopped) {
              return Icon(
                Icons.favorite,
                size: 35,
                color: Color(0xFFC7D2E3),
              );
            }
            final Music _currentSong = snapshot.data.key.value;
            final List<Music> _favorites = snapshot.data.value;
            final bool _isFavorited = _favorites.contains(_currentSong);
            return IconButton(
              onPressed: () {
                if (_isFavorited) {
                  _globalBloc.removeFromFavorites(_currentSong);
                } else {
                  _globalBloc.addToFavorites(_currentSong);
                }
              },
              icon: Icon(
                Icons.favorite,
                size: 35,
                color: !_isFavorited ? Color(0xFFC7D2E3) : Color(0xFF7B92CA),
              ),
            );
          },
        ),
        StreamBuilder<List<Playback>>(
          stream: _globalBloc.playback$,
          builder:
              (context,  snapshot) {
            if (!snapshot.hasData) {
              return Icon(
                Icons.loop,
                size: 35,
                color: Color(0xFFC7D2E3),
              );
            }
            final List<Playback> _playbackList = snapshot.data;
            final bool _isSelected =
            _playbackList.contains(Playback.repeatSong);
            return IconButton(
              onPressed: () {
                if (!_isSelected) {
                  _globalBloc.updatePlayback(Playback.repeatSong);
                } else {
                  _globalBloc.removePlayback(Playback.repeatSong);
                }
              },
              icon: Icon(
                Icons.loop,
                size: 35,
                color: !_isSelected ? Color(0xFFC7D2E3) : Color(0xFF7B92CA),
              ),
            );
          },
        ),
        StreamBuilder<List<Playback>>(
          stream: _globalBloc.playback$,
          builder:
              (context,  snapshot) {
            if (!snapshot.hasData) {
              return Icon(
                Icons.loop,
                size: 35,
                color: Color(0xFFC7D2E3),
              );
            }
            final List<Playback> _playbackList = snapshot.data;
            final bool _isSelected = _playbackList.contains(Playback.shuffle);
            return IconButton(
              onPressed: () {
                if (!_isSelected) {
                  _globalBloc.updatePlayback(Playback.shuffle);
                } else {
                  _globalBloc.removePlayback(Playback.shuffle);
                }
              },
              icon: Icon(
                Icons.shuffle,
                size: 35,
                color: !_isSelected ? Color(0xFFC7D2E3) : Color(0xFF7B92CA),
              ),
            );
          },
        ),
      ],
    );
  }
}

