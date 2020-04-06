import 'package:flutter_audio_query/flutter_audio_query.dart';

class Music{
  String id;
  String displayName;
  String title;
  String album;
  String fileSize;
  String filePath;
  String albumArtNetwork;
  String artist;
  String artistId;
  String composer;
  int duration;
  String year;
  String track;
  String bookmark;
  String albumId;
  bool isMusic;
  bool isAlarm;
  bool isPodcast;
  bool isRingtone;
  bool isNotification;

  Music({this.id, this.displayName, this.artist,
      this.title, this.album, this.fileSize,
      this.filePath, this.albumArtNetwork, this.artistId,
      this.composer, this.duration,
      this.year, this.track, this.bookmark,
      this.albumId, this.isMusic, this.isAlarm,
      this.isPodcast, this.isRingtone, this.isNotification});

  factory Music.fromMap(Map map){
    return Music(id: map["id"], displayName: map["displayName"],
        title: map["title"], duration: map["duration"],
        album: map["album"], filePath: map["filePath"],
        fileSize: map["fileSize"], albumId: map["albumId"],
        artist: map["artist"], artistId: map["artistId"],
        albumArtNetwork: map["albumArtwork"], composer: map["composer"],
        year: map["year"], track: map["track"],
        bookmark: map["bookmark"], isMusic: map["isMusic"],
        isAlarm: map["isAlarm"], isPodcast: map["isPodcast"],
        isRingtone: map["isRingtone"],isNotification: map["isNotification"]);
  }

  factory Music.fromSongInfo(SongInfo songInfo){
    return Music(id: songInfo.id, displayName: songInfo.displayName,
    title: songInfo.title, duration: int.parse(songInfo.duration),
    album: songInfo.album, filePath: songInfo.filePath,
    fileSize: songInfo.fileSize, albumId: songInfo.albumId,
    artist: songInfo.artist, artistId: songInfo.artistId,
    albumArtNetwork: songInfo.albumArtwork, composer: songInfo.composer,
    year: songInfo.year, track: songInfo.track,
    bookmark: songInfo.bookmark, isMusic: songInfo.isMusic,
    isAlarm: songInfo.isAlarm, isPodcast: songInfo.isPodcast,
    isRingtone: songInfo.isRingtone,isNotification: songInfo.isNotification);
  }

  Map<String, dynamic> toMap(Music song){
    return {
      "id" : song.id,
      "displayName" : song.displayName,
      "title" : song.title,
      "duration" : song.duration,
      "album" : song.album,
      "filePath" : song.filePath,
      "fileSize" : song.fileSize,
      "albumId" : song.albumId,
      "artist" : song.artist,
      "artistId" : song.artistId,
      "albumArtwork" : song.albumArtNetwork,
      "composer" : song.composer,
      "year" : song.year,
      "track" : song.track,
      "bookmark" : song.bookmark,
      "isMusic" : song.isMusic,
      "isAlarm": song.isAlarm,
      "isPodcast" : song.isPodcast,
      "isRingtone" : song.isRingtone,
      "isNotification" : song.isNotification
    };
  }

  @override
  String toString() {
    return "id: $id , displayName: $displayName, title: $title, "+
    "duration: $duration, album: $album, filePath: $filePath, "+
    "fileSize: $fileSize, albumId: $albumId, artist: $artist, " +
    "artistId: $artistId, albumArtwork: $albumArtNetwork, "+
    "composer: $composer, year: $year, track: $track, bookmark: $bookmark, "+
    "isMusic: $isMusic, isAlarm: $isAlarm, isPodcast: $isPodcast, "+
    "isRingtone: $isRingtone, isNotification: $isNotification";
  }
}