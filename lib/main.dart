import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flappy/game_play.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy',
      home: GameWidget(game: GamePlay()),
    );
  }
}
