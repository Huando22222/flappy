import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy/component/background.dart';
import 'package:flappy/component/ground.dart';
import 'package:flappy/component/pipe.dart';
import 'package:flappy/component/pipe_manager.dart';
import 'package:flappy/component/player.dart';
import 'package:flappy/component/score.dart';
import 'package:flutter/material.dart';

class GamePlay extends FlameGame with TapDetector, HasCollisionDetection {
  late Player player;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  @override
  FutureOr<void> onLoad() {
    background = Background(size);
    add(background);
    player = Player();
    add(player);
    ground = Ground();
    add(ground);

    pipeManager = PipeManager();
    add(pipeManager);

    scoreText = ScoreText();
    add(scoreText);
    return super.onLoad();
  }

  @override
  void onTap() {
    player.jump();
    super.onTap();
  }

  int score = 0;
  void increaseScore() {
    score++;
  }

  bool isGameOver = false;
  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    pauseEngine();

    showDialog(
      context: buildContext!,
      builder: (context) => AlertDialog(
        title: Text("Game Over"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text("Restart"),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    isGameOver = false;
    player.position = Vector2(100, 100);
    player.velocity = 0.0;
    score = 0;
    children.whereType<Pipe>().forEach(
          (pipe) => pipe.removeFromParent(),
        );
    resumeEngine();
  }
}
