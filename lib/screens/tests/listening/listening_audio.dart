// import 'dart:async';
//
// import 'package:dva232_project/widgets/circular_button.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';

//import 'package:just_audio2/just_audio.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audio_cache.dart';

// import '../../../theme.dart';


// class ListeningAudio { //extends AudioPlayer
//   String _thatUrl = "https://luan.xyz/files/audio/ambient_c_motion.mp3";
//   String localFilePath;
//
//   String mp3Uri = '';
//   AudioPlayer player = AudioPlayer();
//   AudioCache audioCache = AudioCache();
//
//
//   ListeningAudio({this.player});
//
//   Future initPlayer() async {
//
//     final bytes = await readBytes(_thatUrl);
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/audio.mp3');
//     await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
//
//     if (Platform.isIOS) {
//       if (audioCache.fixedPlayer != null) {
//         audioCache.fixedPlayer.startHeadlessService();
//       }
//     }
//     mp3Uri = file.uri.toString();
//   }
//
//   bool playSound(bool _isPlaying, AudioPlayer player) {
//     if (_isPlaying == false) {
//       player.play(mp3Uri);
//       _isPlaying=true;
//     } else if (_isPlaying==true) {
//       player.pause();
//       _isPlaying=false;
//     }
//     return _isPlaying;
//   }
// //
//
// }
