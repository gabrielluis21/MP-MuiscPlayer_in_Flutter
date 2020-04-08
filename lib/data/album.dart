import 'music.dart';

class Album {
  int _id;
  String _name;
  String _art;
  String _artist;

  int get id => _id;
  String get name => _name;
  String get art => _art;
  String get artist => _artist;

  set id(value){_id = value;}
  set name(value){_name = value;}
  set artist(value){_artist = value;}
  set art(value){_art = value;}

  Album(this._id, this._name, this._art, this._artist);

  factory Album.fromSong(Music song) {
    return Album(song.albumId, song.album, song.albumArtNetwork, song.artist);
  }

  @override
  String toString() {
    return 'id: $_id, name: $_name, art: $art, artist: $_artist';
  }
}