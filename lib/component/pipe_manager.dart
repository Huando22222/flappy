import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappy/component/pipe.dart';
import 'package:flappy/game_play.dart';

class PipeManager extends Component with HasGameReference<GamePlay> {
  double pipeSpawnTimer = 0;
  @override
  void update(double dt) {
    pipeSpawnTimer += dt;

    const double pipeInterval = 2;
    if (pipeSpawnTimer > pipeInterval) {
      pipeSpawnTimer = 0;
      spawnPipe();
    }
    super.update(dt);
  }

  void spawnPipe() {
    final double groundHeight = game.ground.size.y;
    final double screenHeight = game.size.y;
    final double pipeWidth = 36;
    // final double pipeWidth = game.size.x * 0.2;
    final double pipeGap = game.gameStatusBloc.state.pipeGap.toDouble();
    final double minPipeHeight = 50;

    final double maxPipeHeight =
        screenHeight - groundHeight - pipeGap - minPipeHeight;

    final double bottomPipeHeight =
        minPipeHeight + Random().nextDouble() * (maxPipeHeight - minPipeHeight);
    final double topPipeHeight =
        screenHeight - groundHeight - bottomPipeHeight - pipeGap;

    final bottomPipe = Pipe(
      Vector2(game.size.x, screenHeight - groundHeight - bottomPipeHeight),
      Vector2(pipeWidth, bottomPipeHeight),
      isTopPipe: false,
    );

    final topPipe = Pipe(
      Vector2(game.size.x, 0),
      Vector2(pipeWidth, topPipeHeight),
      isTopPipe: true,
    );

    game.add(bottomPipe);
    game.add(topPipe);
  }

  void removeAllPipes() {
    game.children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());
  }
}
