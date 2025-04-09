// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum GameStatus {
  play,
  initial,
  gameOver,
}

enum GameMode {
  normal,
  range,
}

class GameStatusState extends Equatable {
  final int score;
  final GameMode gameMode;
  final GameStatus status;
  const GameStatusState({
    required this.score,
    required this.gameMode,
    required this.status,
  });

  const GameStatusState.initial()
      : this(
          score: 0,
          gameMode: GameMode.normal,
          status: GameStatus.initial,
        );

  GameStatusState copyWith({
    int? score,
    GameMode? gameMode,
    GameStatus? status,
  }) {
    return GameStatusState(
      score: score ?? this.score,
      gameMode: gameMode ?? this.gameMode,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [score, gameMode, status];
}
