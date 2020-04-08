import 'dart:convert';

import 'package:mymusicplayer/data/album.dart';

import 'package:http/http.dart' as http;

const URL = "rapidapi's deezer api url";
const HEADERS = {
  "rapidapi-host":"host",
  "key":"your rapidapi user key"
};

class AlbumImages{
  /*
  * This class is to get cover album image from deezer using rapid api
  * */
  AlbumImages();


  void albumFromNetwork(Album album) async{
    await http.get('$URL?q=${album.name}', headers: HEADERS).then((response){
      final resp = jsonDecode(response.body);
      print(resp["data"]);
    });
  }
}