import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/data/music.dart';
import 'package:mymusicplayer/data/player_state.dart';
import 'package:rxdart/rxdart.dart';

class NowPlayingSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _musicBloc = BlocProvider.getBloc<MusicPlayerBloc>();

    return StreamBuilder<MapEntry<Duration, MapEntry<PlayerState, Music>>>(
      stream: CombineLatestStream.combine2(_musicBloc.position$,
          _musicBloc.playerState$, (a, b) => MapEntry(a, b)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Slider(
            value: 0,
            onChanged: (double value) => null,
            activeColor: Colors.blue,
            inactiveColor: Color(0xFFCEE3EE),
          );
        }
        if (snapshot.data.value.key == PlayerState.stopped) {
          return Slider(
            value: 0,
            onChanged: (double value) => null,
            activeColor: Colors.blue,
            inactiveColor: Color(0xFFCEE3EE),
          );
        }
        final Duration _currentDuration = snapshot.data.key;
        final Music _currentSong = snapshot.data.value.value;
        final int _milliseconds = _currentDuration.inMilliseconds;
        final int _songDurationInMilliseconds = _currentSong.duration;
        return Slider(
          min: 0,
          max: _songDurationInMilliseconds.toDouble(),
          value: _songDurationInMilliseconds > _milliseconds
              ? _milliseconds.toDouble() : _songDurationInMilliseconds.toDouble(),
          onChangeStart: (double value) => _musicBloc.invertSeekingState(),
          onChanged: (double value) {
            final _duration = Duration(
              milliseconds: value.toInt(),
            );
            _musicBloc.updatePosition(_duration);
          },
          onChangeEnd: (double value) {
            _musicBloc.invertSeekingState();
            _musicBloc.audioSeek(value / 1000);

          },
          activeColor: Colors.blue,
          inactiveColor: Color(0xFFCEE3EE),
        );
      },
    );
  }
}
