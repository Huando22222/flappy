import 'dart:async';
import 'dart:math' show pi;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/component/audio_manager.dart';
import 'package:flappy/game_play.dart';
import 'package:flappy/value.dart';

class Pipe extends PositionComponent
    with CollisionCallbacks, HasGameReference<GamePlay> {
  final bool isTopPipe;
  bool isScored = false;

  Pipe(Vector2 position, Vector2 size, {required this.isTopPipe})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;
    final sprite = await Sprite.load('pipes/pipe_9tilebox.png');
    final tileSize = 13;

    final nineTileBox = NineTileBox(
      sprite,
      tileSize: tileSize,
      destTileSize: tileSize,
    );

    final nineTileComponent = NineTileBoxComponent(
      nineTileBox: nineTileBox,
      size: size,
    );
    if (isTopPipe) {
      angle = pi;
      position += Vector2(size.x, size.y);
    }
    add(nineTileComponent);
    add(RectangleHitbox(size: size));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x -= Value.groundScrollingSpeed * dt;
    if (position.x + size.x <= 0) {
      removeFromParent();
    }

    if (game.player != null) {
      if (!isScored && position.x < game.player!.x) {
        isScored = true;
        if (!isTopPipe) {
          game.audioManager.playSfx(key: AudioKey.point);
          game.increaseScore();
        }
      }
    }
    super.update(dt);
  }
}
