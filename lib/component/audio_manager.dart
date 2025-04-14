import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy/bloc/game_status_state.dart';
import 'package:flappy/game_play.dart';

enum AudioKey {
  die,
  hit,
  point,
  swooshing,
  wing,
  click,
  start,
}

final Map<GameMode, Map<AudioKey, String>> _modeSpecificAudios = {
  GameMode.blueBird: _audioBird,
  // GameMode.redBird: _audioBird,
  // GameMode.yellowBird: _audioBird,
  GameMode.plane: _audioPlane,
};

Map<AudioKey, String> _audioBird = {
  AudioKey.die: 'flappy_bird/sfx_die.wav',
  AudioKey.hit: 'flappy_bird/sfx_hit.wav',
  AudioKey.point: 'flappy_bird/sfx_point.wav',
  AudioKey.swooshing: 'flappy_bird/sfx_swooshing.wav',
  AudioKey.wing: 'flappy_bird/sfx_wing.wav',
  AudioKey.click: 'click.ogg',
  AudioKey.start: 'start.mp3',
};
Map<AudioKey, String> _audioPlane = {
  AudioKey.die: 'flappy_bird/sfx_die.wav',
  AudioKey.hit: 'flappy_bird/sfx_hit.wav',
  AudioKey.point: 'flappy_bird/sfx_point.wav',
  AudioKey.swooshing: 'flappy_bird/sfx_swooshing.wav',
  AudioKey.wing: 'flappy_bird/sfx_wing.wav',
  AudioKey.click: 'click.ogg',
  AudioKey.start: 'start.mp3',
};

class AudioManager extends PreservedComponent with HasGameReference<GamePlay> {
  @override
  FutureOr<void> onLoad() async {
    await FlameAudio.bgm.initialize();
    await FlameAudio.bgm.play('music.ogg', volume: .5);

    await FlameAudio.audioCache.loadAll(
      // _audioBird.values.toList(),
      _modeSpecificAudios.values.expand((e) => e.values).toSet().toList(),
    );
    return super.onLoad();
  }

  void playSfx({
    required AudioKey key,
  }) {
    final isBirdMode =
        game.gameStatusBloc.state.gameMode == GameMode.blueBird ||
            game.gameStatusBloc.state.gameMode == GameMode.redBird ||
            game.gameStatusBloc.state.gameMode == GameMode.yellowBird;

    final modeAudios = isBirdMode ? _audioBird : _audioPlane;

    final file = modeAudios[key];
    if (file != null) {
      FlameAudio.play(file);
    }
  }
}
