import 'dart:developer';

import 'package:flappy/bloc/game_status_event.dart';
import 'package:flappy/bloc/game_status_state.dart';
import 'package:flappy/value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameStatusBloc extends Bloc<GameStatusEvent, GameStatusState> {
  GameStatusBloc() : super(const GameStatusState.initial()) {
    on<ModeEventChange>((event, emit) {
      emit(state.copyWith(gameMode: event.gameMode));
    });

    on<ScoreEventAdd>(
      (event, emit) {
        final newScore = event.score + state.score;
        final double reductionPercentage =
            (newScore <= 100) ? (newScore / 100) * 60 : 60;

        final int newPipeGap =
            (Value.initialPipeGap * (100 - reductionPercentage) / 100).round();

        emit(state.copyWith(
          score: newScore,
          pipeGap: newPipeGap,
        ));
      },
    );

    on<StatusEventChange>((event, emit) {
      GameStatusState newState;

      if (event.status == GameStatus.play) {
        log("message: play");
        newState = state.copyWith(
            score: 0, pipeGap: Value.initialPipeGap, status: event.status);
      } else {
        log("message: ${event.status.name}");
        newState = state.copyWith(status: event.status);
      }

      emit(newState);
    });

    on<TestEvent>((event, emit) {
      emit(state.copyWith(pipeGap: event.pipeGap));
    });
  }
}
