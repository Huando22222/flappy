// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flappy/value.dart';

enum GameStatus {
  play,
  initial,
  gameOver,
}

enum GameMode {
  blueBird,
  redBird,
  yellowBird,
  plane,
}

class GameStatusState extends Equatable {
  final int score;
  final GameMode gameMode;
  final GameStatus status;
  final int pipeGap;
  const GameStatusState({
    required this.score,
    required this.gameMode,
    required this.status,
    required this.pipeGap,
  });

  const GameStatusState.initial()
      : this(
          score: 0,
          gameMode: GameMode.blueBird,
          status: GameStatus.initial,
          pipeGap: Value.initialPipeGap,
        );

  GameStatusState copyWith({
    int? score,
    GameMode? gameMode,
    GameStatus? status,
    int? pipeGap,
  }) {
    return GameStatusState(
      score: score ?? this.score,
      gameMode: gameMode ?? this.gameMode,
      status: status ?? this.status,
      pipeGap: pipeGap ?? this.pipeGap,
    );
  }

  @override
  List<Object> get props => [score, gameMode, status, pipeGap];
}
