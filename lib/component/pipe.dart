import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/game_play.dart';
import 'package:flappy/value.dart';

class Pipe extends SpriteComponent
    with CollisionCallbacks, HasGameReference<GamePlay> {
  final bool isTopPipe;
  bool isScored = false;
  Pipe(Vector2 position, Vector2 size, {required this.isTopPipe})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(isTopPipe ? 'pipe1_top.png' : 'pipe1.png');
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x -= Value.groundScrollingSpeed * dt;
    if (position.x + size.x <= 0) {
      removeFromParent();
    }

    if (!isScored && position.x < game.player.x) {
      isScored = true;
      if (isTopPipe) {
        game.increaseScore();
      }
    }
    super.update(dt);
  }
}
