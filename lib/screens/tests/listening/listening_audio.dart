import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';


class ListeningAudio extends AudioPlayer{
  Duration _duration=Duration();
  Duration _position=Duration();

  String mp3Uri='';
  AudioPlayer player = AudioPlayer();
  AudioCache audioCache = AudioCache(prefix: 'assets/sneeze.mp3');

  ListeningAudio({this.player});

  void loadSound() async{
    final ByteData data = await rootBundle.load('assets/sneeze.mp3');
    Directory tempDir =await getTemporaryDirectory();
    File tempFile=File('${tempDir.path}/sneeze.mp3}');
    await tempFile.writeAsBytes(data.buffer.asUint8List(), flush:true);
    mp3Uri=tempFile.uri.toString();
  }
  int playSound(int _click) {
    if(_click==0) {
      player.play(mp3Uri);
      _click++;
    }else if(_click==1){
      player.pause();
      _click=0;
    }
    return _click;
  }






}