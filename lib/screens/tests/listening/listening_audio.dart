import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';


class ListeningAudio extends AudioPlayer{

  String _testUrl="https://luan.xyz/files/audio/ambient_c_motion.mp3";
  String localFilePath;

  String mp3Uri='';
  AudioPlayer player =AudioPlayer();
  //
  ListeningAudio({this.player});

  Future initPlayer() async{
    // final ByteData data = await rootBundle.load('assets/sneeze.mp3');
    // Directory tempDir =await getTemporaryDirectory();
    // File tempFile=File('${tempDir.path}/sneeze.mp3}');
    // await tempFile.writeAsBytes(data.buffer.asUint8List(), flush:true);
    //mp3Uri=tempFile.uri.toString();
    final bytes = await readBytes(_testUrl);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush:true);
    // await file.writeAsBytes(bytes);
    // if (await file.exists()) {
    //   setState(() {
    //     localFilePath = file.path;
    //   });
    // }
    mp3Uri=file.uri.toString();
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
  //



}



