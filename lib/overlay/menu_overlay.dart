import 'dart:math' show pi;

import 'package:flappy/bloc/game_status_bloc.dart';
import 'package:flappy/bloc/game_status_event.dart';
import 'package:flappy/bloc/game_status_state.dart';
import 'package:flappy/game_play.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuOverlay extends StatelessWidget {
  final GamePlay gameRef;
  const MenuOverlay({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: BlocConsumer<GameStatusBloc, GameStatusState>(
          builder: (context, state) {
            return Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.black54),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/get_ready.png",
                    width: size.width * 0.5,
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(
                    height: size.height * 0.3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context
                                .read<GameStatusBloc>()
                                .add(ModeEventChange(GameMode.normal));
                          },
                          child: Transform(
                            transform: Matrix4.identity()..rotateY(pi),
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/arrow_forward_icon.png",
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (state.gameMode == GameMode.normal)
                          Image.asset(
                            "assets/images/player.png",
                            width: size.width * 0.5,
                            fit: BoxFit.fitWidth,
                          )
                        else
                          Image.asset(
                            "assets/images/arrow_forward_icon.png",
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<GameStatusBloc>()
                                .add(ModeEventChange(GameMode.range));
                          },
                          child: Image.asset(
                            "assets/images/arrow_forward_icon.png",
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      gameRef.overlays.remove('menu');
                      context
                          .read<GameStatusBloc>()
                          .add(StatusEventChange(GameStatus.play));
                    },
                    child: Image.asset(
                      "assets/images/play_icon.png",
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {},
          listenWhen: (previous, current) =>
              previous.gameMode != current.gameMode
          // &&current.status == GameStatus.gameOver,
          ),
    );
  }
}
