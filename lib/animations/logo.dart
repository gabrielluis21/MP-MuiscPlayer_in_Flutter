
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mymusicplayer/blocs/music_player_bloc.dart';
import 'package:mymusicplayer/effects/grow_and_opacity.dart';
import 'package:mymusicplayer/screens/home_screen.dart';

class LogoScreen extends StatefulWidget {
  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  Animation<double> animation2;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5)
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation2 = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    animation.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        controller.reverse();
        BlocProvider.getBloc<MusicPlayerBloc>().fetchSongs();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeScreen()));
      }
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          GrowAndOpacityTransition(
            child: Image.asset('assets/images/logo_app_music.png'),
            animation: animation,
          ),
          GrowAndOpacityTransition(
            child: Text("Music Player",
              style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),),
            animation: animation2,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

