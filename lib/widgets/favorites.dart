import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/tiles/music_tile.dart';

class Favorites extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final musicBloc = BlocProvider.getBloc<MusicPlayerBloc>();
    return Container(
      height: 150,
      width: 300,
      child: StreamBuilder(
        stream: musicBloc.favorites$,
        builder: (context, snapshot){
          if(!snapshot.hasData) {
            return Center(
              child: Text("Nenhuma música favorita foi encontrada",
                style: TextStyle(fontSize: 18, color: Colors.white),),
            );
          }else{
            return ListView.builder(
             itemCount: snapshot.data.length,
             itemBuilder: (context, index){
               return MusicTile(music: snapshot.data[index],);
            });
          }
        },
      ),
    );
  }
}
