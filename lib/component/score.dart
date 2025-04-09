import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flappy/bloc/game_status_bloc.dart';
import 'package:flappy/bloc/game_status_state.dart';
import 'package:flappy/game_play.dart';
import 'package:flutter/material.dart';

class ScoreText extends TextComponent
    with
        HasGameReference<GamePlay>,
        FlameBlocListenable<GameStatusBloc, GameStatusState> {
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
    add(FlameBlocListener<GameStatusBloc, GameStatusState>(
      listenWhen: (previousState, newState) {
        return previousState.score != newState.score;
        // return newState.status == GameStatus.play;
      },
      onNewState: (state) {
        text = state.score.toString();
      },
    ));

    position = Vector2(
      (game.size.x - size.x) / 2,
      game.size.y - (game.ground.size.y - size.y) / 2,
    );

    return super.onLoad();
  }
}
