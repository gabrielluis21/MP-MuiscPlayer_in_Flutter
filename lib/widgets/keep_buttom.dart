import 'package:flutter/material.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/animations/logo.dart';

class KeepButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final musicBloc = BlocProvider.getBloc<MusicPlayerBloc>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.red,
      ),
      child: FlatButton(
        onPressed: () async{
          await musicBloc.fetchSongs().whenComplete((){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => LogoScreen()
            )); });
        },
        child: Text("Continuar normalmente.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
