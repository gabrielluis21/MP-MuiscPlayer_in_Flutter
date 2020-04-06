import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/data/music.dart';
import 'package:mymusicplayer/data/player_state.dart';


class PlayerControls extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _musicBloc = BlocProvider.getBloc<MusicPlayerBloc>();

    return Container(
      height: 100,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 245,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xFFDCE4F4),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: Offset(2, 1.5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: GestureDetector(
                      onTap: () =>
                          _musicBloc.playPreviousSong(),
                      child: Icon(
                        Icons.fast_rewind,
                        color: Color(0xFF7B92CA),
                        size: 40,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () => _musicBloc.playNextSong(),
                      child: Icon(
                        Icons.fast_forward,
                        color: Color(0xFF7B92CA),
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<MapEntry<PlayerState, Music>>(
                stream: _musicBloc.playerState$,
                builder: (BuildContext context,
                    AsyncSnapshot<MapEntry<PlayerState, Music>> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  final PlayerState _state = snapshot.data.key;
                  final Music _currentSong = snapshot.data.value;
                  return GestureDetector(
                    onTap: () {
                      if (_currentSong.filePath == null) {
                        return;
                      }
                      if (PlayerState.paused == _state) {
                        _musicBloc.playMusic(_currentSong);
                      } else {
                        _musicBloc.pauseMusic(_currentSong);
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 30,
                            offset: Offset(2, 1.5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedCrossFade(
                          duration: Duration(milliseconds: 200),
                          crossFadeState: _state == PlayerState.playing
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: Icon(
                            Icons.pause,
                            size: 50,
                            color: Color(0xFF7B92CA),
                          ),
                          secondChild: Icon(
                            Icons.play_arrow,
                            size: 50,
                            color: Color(0xFF7B92CA),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}


