import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/component/ground.dart';
import 'package:flappy/component/pipe.dart';
import 'package:flappy/game_play.dart';
import 'package:flappy/value.dart';

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameReference<GamePlay> {
  Player()
      : super(
          position: Vector2(100, 100),
        );

  double velocity = 0.0;
  final double gravity = Value.gravity;
  final double jumpForce = Value.jumpForce;

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('player.png');
    size *= 0.18;

    add(
      PolygonHitbox(
        [
          Vector2(size.x * 0.15, size.y * 0.5),
          Vector2(size.x * 0.15, 0),
          Vector2(size.x * 0.25, 0),
          Vector2(size.x * 0.35, size.y * 0.5),
          Vector2(size.x * 0.90, size.y * 0.5),
          Vector2(size.x, size.y * 0.7),
          Vector2(size.x * 0.9, size.y),
          Vector2(size.x * 0.3, size.y),
          Vector2(0, size.y * 0.7),
        ],
      ),
    );
    debugMode = true;
    return super.onLoad();
  }

  void jump() {
    velocity = jumpForce;
  }

  @override
  void update(double dt) {
    velocity += gravity * dt;
    position.y += velocity * dt;
    angle = (velocity / 500).clamp(-0.5, 0.5);
    handleScreenBounds();
    super.update(dt);
  }

  void handleScreenBounds() {
    if (position.y < 0) {
      position.y = 0;
      velocity = 0;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Ground) {
      game.gameOver();
    }

    if (other is Pipe) {
      game.gameOver();
    }
    super.onCollision(intersectionPoints, other);
  }
}
