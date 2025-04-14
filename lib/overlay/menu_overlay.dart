import 'dart:developer';
import 'dart:math' show pi;

import 'package:flappy/bloc/game_status_bloc.dart';
import 'package:flappy/bloc/game_status_event.dart';
import 'package:flappy/bloc/game_status_state.dart';
import 'package:flappy/component/audio_manager.dart';
import 'package:flappy/game_play.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprite/sprite.dart';

class MenuOverlay extends StatelessWidget {
  final GamePlay gameRef;
  const MenuOverlay({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: BlocBuilder<GameStatusBloc, GameStatusState>(
        builder: (context, state) {
          String url;
          if (state.gameMode == GameMode.blueBird) {
            url = "animated_bluebird_51x12";
          } else if (state.gameMode == GameMode.redBird) {
            url = "animated_redbird_51x12";
          } else if (state.gameMode == GameMode.yellowBird) {
            url = "animated_yellowbird_51x12";
          } else if (state.gameMode == GameMode.plane) {
            url = "player2";
          } else {
            url = "animated_bluebird_51x12";
          }
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
                          final current =
                              context.read<GameStatusBloc>().state.gameMode;
                          final modes = GameMode.values;
                          final prevIndex =
                              (current.index - 1 + modes.length) % modes.length;
                          final prevMode = modes[prevIndex];
                          context
                              .read<GameStatusBloc>()
                              .add(ModeEventChange(prevMode));
                          gameRef.audioManager.playSfx(key: AudioKey.click);
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
                      if (state.gameMode == GameMode.plane)
                        Image.asset(
                          "assets/images/players/$url.png",
                          width: size.width * 0.4,
                          fit: BoxFit.fitWidth,
                        )
                      else
                        Sprite(
                          scale: 4,
                          size: Size(17, 12),
                          stepTime: 200,
                          amount: 3,
                          imagePath: 'assets/images/players/$url.png',
                        ),
                      GestureDetector(
                        onTap: () {
                          final current =
                              context.read<GameStatusBloc>().state.gameMode;
                          final modes = GameMode.values;
                          final nextIndex = (current.index + 1) % modes.length;
                          final nextMode = modes[nextIndex];
                          context
                              .read<GameStatusBloc>()
                              .add(ModeEventChange(nextMode));
                          gameRef.audioManager.playSfx(key: AudioKey.click);
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
                    context
                        .read<GameStatusBloc>()
                        .add(StatusEventChange(status: GameStatus.play));
                    gameRef.audioManager.playSfx(key: AudioKey.start);
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
      ),
    );
  }
}
