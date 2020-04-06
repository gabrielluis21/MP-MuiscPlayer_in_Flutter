import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymusicplayer/animations/sound_cloud_button.dart';
import 'package:mymusicplayer/animations/spotify_button.dart';
import 'package:mymusicplayer/widgets/keep_buttom.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown]);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Column(
        children: <Widget>[
          Image.asset("assets/images/logo_app_music.png"),
          SizedBox(height: 15,),
          SpotifyButton(),
          SizedBox(height: 15,),
          SoundCloudButton(),
          SizedBox(height: 15,),
          KeepButton(),
         ],
        ),
    );
  }
}
