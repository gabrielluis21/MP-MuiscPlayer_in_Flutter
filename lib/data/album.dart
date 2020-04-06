import 'music.dart';

class Album {
  String _id;
  String _name;
  String _art;
  String _artist;

  String get id => _id;
  String get name => _name;
  String get art => _art;
  String get artist => _artist;

  Album(this._id, this._name, this._art, this._artist);

  factory Album.fromSong(Music song) {
    return Album(song.albumId, song.album, song.albumArtNetwork, song.artist);
  }
}