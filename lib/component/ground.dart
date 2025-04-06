import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/game_play.dart';
import 'package:flappy/value.dart';

class Ground extends SpriteComponent
    with HasGameReference<GamePlay>, CollisionCallbacks {
  Ground() : super();

  @override
  Future<void> onLoad() async {
    size = Vector2(2 * game.size.x, game.size.y * 0.2);
    position = Vector2(0, game.size.y * 0.8);
    sprite = await Sprite.load('ground.png');

    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x -= Value.groundScrollingSpeed * dt;

    if (position.x + size.x / 2 <= 0) {
      position.x = 0;
    }
    super.update(dt);
  }
}
