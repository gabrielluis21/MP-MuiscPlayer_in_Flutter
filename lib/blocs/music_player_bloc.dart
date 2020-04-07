import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_media_notification/flutter_media_notification.dart';
import 'package:mymusicplayer/data/album.dart';
import 'package:mymusicplayer/data/music.dart';
import 'package:mymusicplayer/data/playback.dart';
import 'package:mymusicplayer/data/player_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicPlayerBloc {
  BehaviorSubject<List<Music>> _songs$;
  BehaviorSubject<List<Album>> _albums$;
  BehaviorSubject<MapEntry<PlayerState, Music>> _playerState$;
  BehaviorSubject<MapEntry<List<Music>, List<Music>>>
  _playlist$; //key is normal, value is shuffle
  BehaviorSubject<Duration> _position$;
  BehaviorSubject<List<Playback>> _playback$;
  BehaviorSubject<List<Music>> _favorites$;
  BehaviorSubject<bool> _isAudioSeeking$;

  FlutterAudioQuery _query = FlutterAudioQuery();
  AudioPlayer _audioPlayer;
  Music _defaultSong;

  BehaviorSubject<List<Music>> get songs$ => _songs$;
  BehaviorSubject<List<Album>> get albums$ => _albums$;
  BehaviorSubject<MapEntry<PlayerState, Music>> get playerState$ =>
      _playerState$;
  BehaviorSubject<Duration> get position$ => _position$;
  BehaviorSubject<List<Playback>> get playback$ => _playback$;
  BehaviorSubject<List<Music>> get favorites$ => _favorites$;

  MusicPlayerBloc() {
    _initDeafultSong();
    _initStreams();
    _initObservers();
    _initAudioPlayer();
    _initNotificationActions();
  }

  Future<void> fetchSongs() async {
    List<Music> musics = [];
    await _query.getSongs().then(
          (data) {
        data.forEach((element){
          if(element.filePath.contains('/Music') ||
              element.filePath.contains("/music")){
            musics.add(new Music.fromSongInfo(element));
          }
        });
      },
    );
    _songs$.add(musics);
  }

  void playMusic(Music song) {
    _audioPlayer.play(song.filePath);
    updatePlayerState(PlayerState.playing, song);
    _showNotification(song.displayName, song.artist, true);
  }

  void pauseMusic(Music song) {
    _audioPlayer.pause();
    updatePlayerState(PlayerState.paused, song);
    _showNotification(song.displayName, song.artist, false);
  }

  void stopMusic() {
    _audioPlayer.stop();
    _hideNotification();
  }

  void updatePlayerState(PlayerState state, Music song) {
    _playerState$.add(MapEntry(state, song));
  }

  void updatePosition(Duration duration) {
    _position$.add(duration);
  }

  void updatePlaylist(List<Music> normalPlaylist) {
    List<Music> _shufflePlaylist = []..addAll(normalPlaylist);
    _shufflePlaylist.shuffle();
    _playlist$.add(MapEntry(normalPlaylist, _shufflePlaylist));
  }

  void _updateAlbums(List<Music> songs) {
    Map<String, Album> _albumsMap = {};
    for (Music song in songs) {
      if (_albumsMap[song.albumId] == null) {
        _albumsMap[song.albumId] = Album.fromSong(song);
      }
    }
    final List<Album> _albums = _albumsMap.values.toList();
    _albums$.add(_albums);
  }

  void playNextSong() {
    if (_playerState$.value.key == PlayerState.stopped) {
      return;
    }
    final Music _currentSong = _playerState$.value.value;
    final bool _isShuffle = _playback$.value.contains(Playback.shuffle);
    final List<Music> _playlist =
    _isShuffle ? _playlist$.value.value : _playlist$.value.key;
    int _index = _playlist.indexOf(_currentSong);
    if (_index == _playlist.length - 1) {
      _index = 0;
    } else {
      _index++;
    }
    stopMusic();
    playMusic(_playlist[_index]);
  }

  void playPreviousSong() {
    if (_playerState$.value.key == PlayerState.stopped) {
      return;
    }
    final Music _currentSong = _playerState$.value.value;
    final bool _isShuffle = _playback$.value.contains(Playback.shuffle);
    final List<Music> _playlist =
    _isShuffle ? _playlist$.value.value : _playlist$.value.key;
    int _index = _playlist.indexOf(_currentSong);
    if (_index == 0) {
      _index = _playlist.length - 1;
    } else {
      _index--;
    }
    stopMusic();
    playMusic(_playlist[_index]);
  }

  void _playSameSong() {
    final Music _currentSong = _playerState$.value.value;
    stopMusic();
    playMusic(_currentSong);
  }

  void _onSongComplete() {
    final List<Playback> _playback = _playback$.value;
    if (_playback.contains(Playback.repeatSong)) {
      _playSameSong();
      return;
    }
    playNextSong();
  }

  void audioSeek(double seconds) {
    _audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  void addToFavorites(Music song) async {
    List<Music> _favorites = _favorites$.value;
    _favorites.add(song);
    _favorites$.add(_favorites);
    await saveFavorites();
  }

  void removeFromFavorites(Music song) async {
    List<Music> _favorites = _favorites$.value;
    _favorites.remove(song);
    _favorites$.add(_favorites);
    await saveFavorites();
  }

  void invertSeekingState() {
    final _value = _isAudioSeeking$.value;
    _isAudioSeeking$.add(!_value);
  }

  void updatePlayback(Playback playback) {
    List<Playback> _value = playback$.value;
    if (playback == Playback.shuffle) {
      final List<Music> _normalPlaylist = _playlist$.value.key;
      updatePlaylist(_normalPlaylist);
    }
    if(playback == Playback.repeatAll){
      final List<Music> _normalPlaylist = _playlist$.value.key;
      updatePlaylist(_normalPlaylist);
    }
    _value.add(playback);
    _playback$.add(_value);
  }

  void removePlayback(Playback playback) {
    List<Playback> _value = playback$.value;
    _value.remove(playback);
    _playback$.add(_value);
  }

  Future<void> saveFavorites() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final List<Music> _favorites = _favorites$.value;
    List<String> _encodedStrings = [];
    for (Music song in _favorites) {
      _encodedStrings.add(_encodeSongToJson(song));
    }
    _prefs.setStringList("favorites", _encodedStrings);
  }

  void retrieveFavorites() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final List<Music> _fetchedSongs = _songs$.value;
    List<String> _savedStrings = _prefs.getStringList("favorites") ?? [];
    List<Music> _favorites = [];
    for (String data in _savedStrings) {
      final Music song = _decodeSongFromJson(data);
      for (var fetchedSong in _fetchedSongs) {
        if (song.id == fetchedSong.id) {
          _favorites.add(fetchedSong);
        }
      }
    }
    _favorites$.add(_favorites);
  }

  String _encodeSongToJson(Music song) {
    final _songMap = Music().toMap(song);
    final data = json.encode(_songMap);
    return data;
  }

  Music _decodeSongFromJson(String ecodedSong) {
    final _songMap = json.decode(ecodedSong);
    final Music _song = Music.fromMap(_songMap);
    return _song;
  }

  Future<void> _hideNotification() async {
    try {
      await MediaNotification.hideNotification();
    } on PlatformException {}
  }

  Future<void> _showNotification(title, author, isPlaying) async {
    try {
      await MediaNotification.showNotification(
          title: title, author: author, isPlaying: isPlaying);
    } on PlatformException {}
  }

   void _initDeafultSong() {
    _defaultSong = Music();
  }

  void _initNotificationActions(){
    MediaNotification.setListener("play", () => playMusic (_playerState$.value.value));
    MediaNotification.setListener("pause", () =>  pauseMusic(_playerState$.value.value));
    MediaNotification.setListener("next", () => playNextSong());
    MediaNotification.setListener("prev", () =>  playPreviousSong());
  }

  void _initObservers() {
    _songs$.listen(
          (List<Music> songs) {
        _updateAlbums(songs);
      },
    ); // push albums from songs
  }

  void _initStreams() {
    _isAudioSeeking$ = BehaviorSubject<bool>.seeded(false);
    _songs$ = BehaviorSubject<List<Music>>();
    _albums$ = BehaviorSubject<List<Album>>();
    _position$ = BehaviorSubject<Duration>();
    _playlist$ = BehaviorSubject<MapEntry<List<Music>, List<Music>>>();
    _playback$ = BehaviorSubject<List<Playback>>.seeded([]);
    _favorites$ = BehaviorSubject<List<Music>>.seeded([]);
    _playerState$ = BehaviorSubject<MapEntry<PlayerState, Music>>.seeded(
      MapEntry(
        PlayerState.stopped,
        _defaultSong,
      ),
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.onAudioPositionChanged.listen((event) {
      updatePosition(event);
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
      _onSongComplete();
    });

  }

  void dispose() {
    _audioPlayer.dispose();
    stopMusic();
    _isAudioSeeking$.close();
    _songs$.close();
    _albums$.close();
    _playerState$.close();
    _playlist$.close();
    _position$.close();
    _playback$.close();
    _favorites$.close();
  }
}