import 'package:mymusicplayer/data/music.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc{
  BehaviorSubject<List<Music>> _filteredSongs$;

  BehaviorSubject<List<Music>> get filteredSongs$ => _filteredSongs$;

  SearchBloc() {
    _filteredSongs$ = BehaviorSubject<List<Music>>.seeded([]);
  }

  void updateFilteredSongs(String filter, List<Music> songs) {
    final _phrase = filter.replaceAll(" ", "").toLowerCase();
    List<Music> _filteredSongs = [];
    if (_phrase.length == 0) {
      _filteredSongs$.add(_filteredSongs);
      return;
    }
    for (Music song in songs) {
      final _songName = song.title.replaceAll(" ", "").toLowerCase();
      final _albumName = song.album.replaceAll(" ", "").toLowerCase();
      final _artistNames =
      song.artist.replaceAll(" ", "").replaceAll(";", "").toLowerCase();
      final _songString = _songName + _albumName + _artistNames;

      if (_songString.contains(_phrase)) {
        _filteredSongs.add(song);
      }
    }

    if (_filteredSongs.length == 0) {
      _filteredSongs$.add(null);
    }

    _filteredSongs$.add(_filteredSongs);
  }

  void dispose() {
    _filteredSongs$.close();
  }
}