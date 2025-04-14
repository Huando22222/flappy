import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flappy/bloc/game_status_bloc.dart';
import 'package:flappy/bloc/game_status_state.dart';
import 'package:flappy/game_play.dart';

class ScoreDisplay extends PositionComponent
    with
        HasGameReference<GamePlay>,
        FlameBlocListenable<GameStatusBloc, GameStatusState> {
  late final Map<int, Sprite> _digitSprites = {};
  final List<SpriteComponent> _digitComponents = [];
  final double spacing;
  final double digitWidth;
  final double digitHeight;
  int _currentScore = 0;

  ScoreDisplay({
    this.spacing = 2.0,
    this.digitWidth = 30.0,
    this.digitHeight = 40.0,
  }) : super(
        // anchor: Anchor.center,
        );

  @override
  FutureOr<void> onLoad() async {
    for (int i = 0; i <= 9; i++) {
      _digitSprites[i] = await game.loadSprite('numbers/${i}_large.png');
    }

    add(FlameBlocListener<GameStatusBloc, GameStatusState>(
      listenWhen: (previousState, newState) {
        return previousState.score != newState.score;
      },
      onNewState: (state) {
        _updateScore(state.score);
      },
    ));

    _updateScore(0);

    position = Vector2(
      game.size.x / 2,
      game.size.y - (game.ground.size.y) / 2,
    );

    return super.onLoad();
  }

  void _updateScore(int newScore) {
    if (_currentScore == newScore) return;
    _currentScore = newScore;

    for (var component in _digitComponents) {
      remove(component);
    }
    _digitComponents.clear();

    String scoreString = newScore.toString();

    double totalWidth = (digitWidth * scoreString.length) +
        (spacing * (scoreString.length - 1));

    double startX = -totalWidth / 2 + digitWidth / 2;

    for (int i = 0; i < scoreString.length; i++) {
      int digit = int.parse(scoreString[i]);
      final digitComponent = SpriteComponent(
        sprite: _digitSprites[digit],
        size: Vector2(digitWidth, digitHeight),
        position: Vector2(
          startX + i * (digitWidth + spacing),
          0,
        ),
        anchor: Anchor.center,
      );

      add(digitComponent);
      _digitComponents.add(digitComponent);
    }

    size = Vector2(totalWidth, digitHeight);
  }
}
