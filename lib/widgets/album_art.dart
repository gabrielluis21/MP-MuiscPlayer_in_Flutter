import 'package:flutter/material.dart';
import 'package:mymusicplayer/data/music.dart';

const URL = "https://deezerdevs-deezer.p.rapidapi.com/album/";
const APIKEY = "fa7bf02584msh53ca5f86407711fp1b0b75jsn3d4d06547307";

class AlbumArtContainer extends StatelessWidget {
  const AlbumArtContainer({
    Key key,
    @required double radius,
    @required double albumArtSize,
    @required Music currentSong,
  })  : _radius = radius,
        _albumArtSize = albumArtSize,
        _currentSong = currentSong,
        super(key: key);

  final double _radius;
  final double _albumArtSize;
  final Music _currentSong;
  

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: _albumArtSize,
            child: FadeInImage(
              placeholder: AssetImage(_currentSong.albumArtNetwork),
              image: AssetImage(
                _currentSong.albumArtNetwork,
              ),
              fit: BoxFit.fill,
            ),
          ),
          Opacity(
            opacity: 0.55,
            child: Container(
              width: double.infinity,
              height: _albumArtSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [
                    0.0,
                    0.85,
                  ],
                  colors: [
                    Color(0xFF47ACE1),
                    Color(0xFFDF5F9D),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}