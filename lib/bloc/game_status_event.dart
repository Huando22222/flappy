import 'package:equatable/equatable.dart';
import 'package:flappy/bloc/game_status_state.dart';

abstract class GameStatusEvent extends Equatable {
  const GameStatusEvent();
}

class ScoreEventAdd extends GameStatusEvent {
  final int score;
  const ScoreEventAdd(this.score);

  @override
  List<Object?> get props => [score];
}

class ModeEventChange extends GameStatusEvent {
  final GameMode gameMode;
  const ModeEventChange(this.gameMode);

  @override
  List<Object?> get props => [gameMode];
}

class StatusEventChange extends GameStatusEvent {
  final GameStatus status;
  const StatusEventChange({required this.status});

  @override
  List<Object?> get props => [status];
}

class TestEvent extends GameStatusEvent {
  final int pipeGap;
  const TestEvent({required this.pipeGap});
  @override
  List<Object?> get props => [pipeGap];
}
