import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

const Map<String, String> audios = {
  'hit': 'hit.mp3',
  'click': 'click.ogg',
  'start': 'start.mp3',
};

class AudioManager extends Component {
  @override
  FutureOr<void> onLoad() async {
    await FlameAudio.bgm.initialize();
    await FlameAudio.bgm.play('music.ogg', volume: .5);
    await FlameAudio.audioCache.loadAll(audios.values.toList());
    return super.onLoad();
  }

  void playSfx(String key) {
    final file = audios[key];
    if (file != null) {
      FlameAudio.play(file);
    }
  }
}
