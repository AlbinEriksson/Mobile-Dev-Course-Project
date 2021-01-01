import 'package:dva232_project/widgets/circular_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

import '../../../theme.dart';

const url1 = 'https://luan.xyz/files/audio/ambient_c_motion.mp3';

class SoundPlayer extends StatefulWidget {
  @override
  _SoundPlayerState createState() => _SoundPlayerState();
}

class _SoundPlayerState extends State<SoundPlayer> {
  Icon _playIcon = Icon(Icons.play_arrow, size: 70.0, color: Colors.white);
  AudioPlayer player = AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CircularButton(
              onPressed: () {
                _getAudio();
              },
              color: LanGuideTheme.primaryColor(context),
              icon: _playIcon,
              size: 70.0,
            ),
          ),
        ),
        slider(),
      ],
    );
  }

  Widget slider() {
    return Slider.adaptive(
      value: position.inSeconds.toDouble(),
      max: duration.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          player.seek(new Duration(seconds:value.toInt()));
        });
      },
    );
  }

  void _getAudio() async{
    String _url="https://luan.xyz/files/audio/ambient_c_motion.mp3";
    if(isPlaying==true){
      var res=await player.pause();
      if(res==1){
        setState(() {
          isPlaying=false;
        });
      }

    }else{
      var res=await player.play(_url, isLocal:true);
      if(res==1){
        setState(() {
          isPlaying=true;
        });
      }
    }
    
    player.onDurationChanged.listen((Duration dur) {
      setState(() {
        duration=dur;
      });
    });
    player.onAudioPositionChanged.listen((Duration pos) {
      setState(() {
        position=pos;
      });
    });
  }
}

class ListeningAudio extends AudioPlayer {
  String _thatUrl = "https://luan.xyz/files/audio/ambient_c_motion.mp3";
  String localFilePath;

  String mp3Uri = '';
  AudioPlayer player = AudioPlayer();
  AudioCache audioCache = AudioCache();

  //
  ListeningAudio({this.player});

  Future initPlayer() async {

    final bytes = await readBytes(_thatUrl);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
    }
    return mp3Uri = file.uri.toString();
  }

  int playSound(int _click) {
    if (_click == 0) {
      player.play(mp3Uri);
      _click++;
    } else if (_click == 1) {
      player.pause();
      _click = 0;
    }
    return _click;
  }
//

}
