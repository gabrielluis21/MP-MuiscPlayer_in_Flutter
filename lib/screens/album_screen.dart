import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/data/album.dart';
import 'package:mymusicplayer/screens/specific_album_screen.dart';
import 'package:mymusicplayer/tiles/album_tile.dart';
import 'package:mymusicplayer/utils/empty_screen.dart';

class AlbumScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _globalBloc = BlocProvider.getBloc<MusicPlayerBloc>();

    return Scaffold(
      body: StreamBuilder<List<Album>>(
        stream: _globalBloc.albums$,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<Album> _albums = snapshot.data;
          if (_albums.length == 0) {
            return EmptyScreen(
              text: "You do not have any albums on your device.",
            );
          }

          return GridView.builder(
            key: PageStorageKey<String>("Albums Screen"),
            padding: EdgeInsets.only(
                left: 16.0, right: 16.0, top: 16.0, bottom: 150),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            physics: BouncingScrollPhysics(),
            itemCount: _albums.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                     builder: (context) =>  SpecificAlbumScreen(album: _albums[index],)
                     ),
                  );
                },
                child: AlbumTile(
                  album: _albums[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
