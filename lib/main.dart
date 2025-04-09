import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flappy/bloc/game_status_bloc.dart';
import 'package:flappy/game_play.dart';
import 'package:flappy/overlay/game_over_overlay.dart';
import 'package:flappy/overlay/menu_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GameStatusBloc()),
      ],
      child: MaterialApp(
        title: 'Flappy',
        home: const GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GamePlay gamePlay;

  @override
  void initState() {
    super.initState();
    gamePlay = GamePlay(gameStatusBloc: context.read<GameStatusBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: gamePlay,
      overlayBuilderMap: {
        'gameOver': (context, game) =>
            GameOverOverlay(gameRef: game as GamePlay),
        'menu': (context, game) => MenuOverlay(gameRef: game as GamePlay),
      },
      initialActiveOverlays: const ['gameOver'],
    );
  }
}
