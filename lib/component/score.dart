import 'dart:async';

import 'package:flame/components.dart';
import 'package:flappy/game_play.dart';
import 'package:flutter/material.dart';

class ScoreText extends TextComponent with HasGameReference<GamePlay> {
  ScoreText()
      : super(
          text: "0",
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        );

  @override
  FutureOr<void> onLoad() {
    position = Vector2(
      (game.size.x - size.x) / 2,
      game.size.y - (game.ground.size.y - size.y) / 2,
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    final newText = game.score.toString();
    if (text != newText) {
      text = newText;
    }
    super.update(dt);
  }
}
