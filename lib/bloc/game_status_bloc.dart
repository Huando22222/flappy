import 'package:flappy/bloc/game_status_event.dart';
import 'package:flappy/bloc/game_status_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameStatusBloc extends Bloc<GameStatusEvent, GameStatusState> {
  GameStatusBloc() : super(const GameStatusState.initial()) {
    on<ModeEventChange>((event, emit) {
      emit(state.copyWith(gameMode: event.gameMode));
    });

    on<ScoreEventAdd>(
      (event, emit) {
        emit(state.copyWith(score: event.score + state.score));
      },
    );

    on<StatusEventChange>((event, emit) {
      emit(state.copyWith(status: event.status));
    });
  }
}
