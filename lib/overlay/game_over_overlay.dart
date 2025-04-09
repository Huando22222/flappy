import 'package:flappy/game_play.dart';
import 'package:flutter/material.dart';

class GameOverOverlay extends StatefulWidget {
  final GamePlay gameRef;
  const GameOverOverlay({super.key, required this.gameRef});

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 0),
      () {
        setState(() {
          _opacity = 1.0;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      onEnd: () {
        if (_opacity == 0.0) {
          widget.gameRef.overlays.remove('gameOver');
        }
      },
      opacity: _opacity,
      duration: const Duration(milliseconds: 500),
      child: Container(
        color: Colors.black.withAlpha(150),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
