import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';

class SpotifyBloc implements BlocBase{

  final StreamController _spotifyController = StreamController();
  Stream get outSpotify => _spotifyController.stream;

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _spotifyController.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }
}