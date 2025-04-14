import 'dart:async';
import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flappy/bloc/game_status_bloc.dart';
import 'package:flappy/bloc/game_status_event.dart';
import 'package:flappy/bloc/game_status_state.dart';
import 'package:flappy/component/audio_manager.dart';
import 'package:flappy/component/background.dart';
import 'package:flappy/component/button.dart';
import 'package:flappy/component/ground.dart';
import 'package:flappy/component/pipe_manager.dart';
import 'package:flappy/component/player.dart';
import 'package:flappy/component/score.dart';

abstract class PreservedComponent extends Component {}

class GameStatusController extends PreservedComponent
    with HasGameReference<GamePlay> {
  @override
  FutureOr<void> onLoad() {
    add(
      FlameBlocProvider<GameStatusBloc, GameStatusState>.value(
        value: game.gameStatusBloc,
        children: [
          FlameBlocListener<GameStatusBloc, GameStatusState>(
            listenWhen: (previousState, newState) {
              return previousState.status != newState.status;
            },
            onNewState: (state) {
              if (state.status == GameStatus.gameOver) {
                //
                game.pauseEngine();
                game.overlays.add('menu');
                // game.overlays.add('gameOver');
              } else if (state.status == GameStatus.play) {
                game.overlays.removeAll(['gameOver', 'menu']);
                game.onNewGame();
              } else if (state.status == GameStatus.initial) {
                game.overlays.add('menu');
                //
              }
            },
          ),
        ],
      ),
    );
  }
}

class GamePlay extends FlameGame with TapDetector, HasCollisionDetection {
  GamePlay({required this.gameStatusBloc});
  final GameStatusBloc gameStatusBloc;

  Player? player;
  ScoreDisplay? scoreText;

  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late AudioManager audioManager;
  @override
  FutureOr<void> onLoad() {
    loadingComponent();

    add(GameStatusController());
    return super.onLoad();
  }

  void loadingComponent() {
    background = Background(size);
    add(background);
    ground = Ground();
    add(ground);
    add(PauseButtonComponent());
    pipeManager = PipeManager();
    add(pipeManager);
    audioManager = AudioManager();
    add(audioManager);
  }

  void onNewGame() {
    if (paused) {
      resumeEngine();
    }

    children.where((element) => element is! PreservedComponent).forEach(
          (element) => element.removeFromParent(),
        );

    loadingComponent();

    add(
      FlameBlocProvider<GameStatusBloc, GameStatusState>.value(
        value: gameStatusBloc,
        children: [
          scoreText = ScoreDisplay(),
          player = Player(),
        ],
      ),
    );
  }

  @override
  void onTap() {
    if (paused) return;
    player?.jump();
    audioManager.playSfx(key: AudioKey.swooshing);
    super.onTap();
  }

  void increaseScore() {
    if (gameStatusBloc.state.status == GameStatus.play) {
      gameStatusBloc.add(ScoreEventAdd(1));
    }
  }
}
