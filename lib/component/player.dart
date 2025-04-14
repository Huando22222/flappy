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
    final gameMode = game.gameStatusBloc.state.gameMode;
    if (gameMode != GameMode.plane) {
      String url;
      if (gameMode == GameMode.blueBird) {
        url = "animated_bluebird_51x12";
      } else if (gameMode == GameMode.redBird) {
        url = "animated_redbird_51x12";
      } else if (gameMode == GameMode.yellowBird) {
        url = "animated_yellowbird_51x12";
      } else {
        url = "animated_bluebird_51x12";
      }
      animation = await game.loadSpriteAnimation(
        'players/$url.png',
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(17, 12),
        ),
      );
      scale = Vector2(2, 2);

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

    if(position.y > game.ground.position.y){game.gameStatusBloc.add(StatusEventChange(status: GameStatus.gameOver));}
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
      game.audioManager.playSfx(key: AudioKey.hit);
      game.audioManager.playSfx(key: AudioKey.die);
      game.gameStatusBloc.add(StatusEventChange(status: GameStatus.gameOver));
    }

    if (other is Pipe) {
      game.audioManager.playSfx(key: AudioKey.hit);
      game.audioManager.playSfx(key: AudioKey.die);
      game.gameStatusBloc.add(StatusEventChange(status: GameStatus.gameOver));
    }
    super.onCollision(intersectionPoints, other);
  }
}
