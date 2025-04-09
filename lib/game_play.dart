import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flappy/bloc/game_status_bloc.dart';
import 'package:flappy/bloc/game_status_event.dart';
import 'package:flappy/bloc/game_status_state.dart';
import 'package:flappy/component/audio_manager.dart';
import 'package:flappy/component/background.dart';
import 'package:flappy/component/ground.dart';
import 'package:flappy/component/pipe.dart';
import 'package:flappy/component/pipe_manager.dart';
import 'package:flappy/component/player.dart';
import 'package:flappy/component/score.dart';
import 'package:flutter/material.dart';

class GameStatusController extends Component with HasGameReference<GamePlay> {
  @override
  FutureOr<void> onLoad() {
    add(
      FlameBlocListener<GameStatusBloc, GameStatusState>(
        listenWhen: (previousState, newState) {
          return previousState.status != newState.status;
        },
        onNewState: (state) {
          if (state.status == GameStatus.gameOver) {
            //
            game.overlays.add('gameOver');
          } else if (state.status == GameStatus.play) {
            //
            game.onNewGame();
          } else if (state.status == GameStatus.initial) {
            game.overlays.add('menu');
            //
          }
        },
      ),
    );
  }
}

class GamePlay extends FlameGame with TapDetector, HasCollisionDetection {
  GamePlay({required this.gameStatusBloc});
  final GameStatusBloc gameStatusBloc;

  late Player player;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  late AudioManager audioManager;
  @override
  FutureOr<void> onLoad() {
    background = Background(size);
    add(background);
    ground = Ground();
    add(ground);
    add(
      FlameBlocProvider<GameStatusBloc, GameStatusState>.value(
        value: gameStatusBloc,
        children: [GameStatusController()],
      ),
    );
    // onNewGame();
    // background = Background(size);
    // add(background);
    // // player = Player();
    // // add(player);
    // ground = Ground();
    // add(ground);
    // // pipeManager = PipeManager();
    // // add(pipeManager);

    // scoreText = ScoreText();
    // add(scoreText);

    // // audioManager = AudioManager();
    // // add(audioManager);

    return super.onLoad();
  }

  void onNewGame() {
    // pipeManager = PipeManager();
    // add(pipeManager);
    if (paused) {
      resumeEngine();
    }
    add(
      FlameBlocProvider<GameStatusBloc, GameStatusState>.value(
        value: gameStatusBloc,
        children: [
          scoreText = ScoreText(),
          player = Player(),
          pipeManager = PipeManager(),
        ],
      ),
    );
    // player = Player();
    // add(player);

    // audioManager = AudioManager();
    // add(audioManager);
  }

  @override
  void onTap() {
    player.jump();
    super.onTap();
  }

  void increaseScore() {
    if (gameStatusBloc.state.status == GameStatus.play) {
      gameStatusBloc.add(ScoreEventAdd(1));
    }
  }

  bool isGameOver = false;
  void gameOver() {
    if (isGameOver) return;
    gameStatusBloc.add(StatusEventChange(GameStatus.gameOver));
    // audioManager.playSfx('hit');
    isGameOver = true;
    pauseEngine();

    // showDialog(
    //   context: buildContext!,
    //   builder: (context) => AlertDialog(
    //     title: Text("Game Over"),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //           resetGame();
    //         },
    //         child: Text("Restart"),
    //       ),
    //     ],
    //   ),
    // );
  }

  void resetGame() {
    isGameOver = false;
    player.position = Vector2(100, 100);
    player.velocity = 0.0;
    // score = 0;
    children.whereType<Pipe>().forEach(
          (pipe) => pipe.removeFromParent(),
        );
    resumeEngine();
  }
}
