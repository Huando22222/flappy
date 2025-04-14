import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flappy/component/audio_manager.dart';
import 'package:flappy/game_play.dart';

class PauseButtonComponent extends SpriteComponent
    with TapCallbacks, HasGameReference<GamePlay> {
  PauseButtonComponent() : super(size: Vector2(50, 50), priority: 10);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('pause.png');
    position = Vector2(game.size.x - 50, game.size.y - 50);
    anchor = Anchor.center;
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.audioManager.playSfx(key: AudioKey.click);
    if (game.paused) {
      game.resumeEngine();
    } else {
      game.pauseEngine();
    }
  }
}
