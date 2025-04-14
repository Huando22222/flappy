import 'dart:async';
import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy/bloc/game_status_event.dart';
import 'package:flappy/bloc/game_status_state.dart';
import 'package:flappy/component/audio_manager.dart';
import 'package:flappy/component/ground.dart';
import 'package:flappy/component/pipe.dart';
import 'package:flappy/game_play.dart';
import 'package:flappy/value.dart';

class Player extends
// SpriteComponent
    SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<GamePlay> {
  Player()
      : super(
          position: Vector2(100, 100),
        ) {
    log("create player");
  }

  double velocity = 0.0;
  final double gravity = Value.gravity;
  final double jumpForce = Value.jumpForce;

  @override
  FutureOr<void> onLoad() async {
    if (game.gameStatusBloc.state.gameMode == GameMode.blueBird) {
      animation = await game.loadSpriteAnimation(
        'players/animated_bluebird_21x12.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(17, 12),
        ),
      );
      // animation = await game.loadSpriteAnimation(
      //   'players/animated_bird.png',
      //   SpriteAnimationData.sequenced(
      //     amount: 3,
      //     stepTime: 0.1,
      //     textureSize: Vector2(34, 24),
      //   ),
      // );

      add(CircleHitbox());
    } else {
      animation = await game.loadSpriteAnimation(
        'players/player2.png',
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 1,
          textureSize: Vector2(78, 40),
        ),
      );
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
    }

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
      // game.gameOver();
      game.audioManager.playSfx(key: AudioKey.hit);
      game.audioManager.playSfx(key: AudioKey.die);
      log('hit Ground');
      game.gameStatusBloc.add(StatusEventChange(status: GameStatus.gameOver));
    }

    if (other is Pipe) {
      game.audioManager.playSfx(key: AudioKey.hit);
      game.audioManager.playSfx(key: AudioKey.die);
      log('hit pipe');
      // game.gameOver();
      game.gameStatusBloc.add(StatusEventChange(status: GameStatus.gameOver));
    }
    super.onCollision(intersectionPoints, other);
  }
}
