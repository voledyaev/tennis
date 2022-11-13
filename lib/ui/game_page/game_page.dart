import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../logic/game_progress_cubit.dart';
import '../../logic/username_input_cubit.dart';
import 'widgets/ball_button.dart';
import 'widgets/current_score_counter.dart';
import 'widgets/game_pause_overlay.dart';
import 'widgets/overall_score_counter.dart';
import 'widgets/start_button.dart';
import 'widgets/unfocusing_gesture_detector.dart';
import 'widgets/username_input.dart';
import 'widgets/username_text.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider(
            create: (context) => UsernameInputCubit(),
            dispose: (context, value) => value.close(),
          ),
          Provider(
            create: (context) => GameProgressCubit(showGameResultDialog: _showGameResultDialog),
            dispose: (context, value) => value.close(),
          ),
        ],
        builder: (context, child) => UnfocusingGestureDetector(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: BlocSelector<GameProgressCubit, GameProgressState, bool>(
              selector: (state) => state.map(
                inactive: (value) => false,
                playing: (value) => true,
              ),
              builder: (context, state) => Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: const [
                              _OverallScores(),
                              Positioned.fill(
                                bottom: -96,
                                child: _CurrentScores(),
                              ),
                            ],
                          ),
                        ),
                        const Align(
                          alignment: Alignment(0, 0.4),
                          child: _BallButtons(),
                        ),
                      ],
                    ),
                  ),
                  if (!state) const GamePauseOverlay(),
                  Padding(
                    padding: const EdgeInsets.all(32) + const EdgeInsets.only(top: 48),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: !state ? const _UsernameInputs() : const _UsernameTexts(),
                    ),
                  ),
                  if (!state) const Center(child: StartButton()),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _showGameResultDialog(String result) async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(result),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('OK'),
            ),
          ],
        ),
      );
}

class _OverallScores extends StatelessWidget {
  const _OverallScores();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BlocSelector<GameProgressCubit, GameProgressState, int>(
            selector: (state) => state.map(
              inactive: (value) => 0,
              playing: (value) => value.firstUserOverallScore,
            ),
            builder: (context, state) => OverallScoreCounter(
              score: state.toString(),
            ),
          ),
          BlocSelector<GameProgressCubit, GameProgressState, int>(
            selector: (state) => state.map(
              inactive: (value) => 0,
              playing: (value) => value.secondUserOverallScore,
            ),
            builder: (context, state) => OverallScoreCounter(
              score: state.toString(),
            ),
          ),
        ],
      );
}

class _CurrentScores extends StatelessWidget {
  const _CurrentScores();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BlocSelector<GameProgressCubit, GameProgressState, String>(
            selector: (state) => state.map(
              inactive: (value) => '0',
              playing: (value) => value.firstUserCurrentScore,
            ),
            builder: (context, state) => CurrentScoreCounter(
              score: state,
            ),
          ),
          BlocSelector<GameProgressCubit, GameProgressState, String>(
            selector: (state) => state.map(
              inactive: (value) => '0',
              playing: (value) => value.secondUserCurrentScore,
            ),
            builder: (context, state) => CurrentScoreCounter(
              score: state,
            ),
          ),
        ],
      );
}

class _BallButtons extends StatelessWidget {
  const _BallButtons();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BallButton(onTap: () => context.read<GameProgressCubit>().makeFirstUserTurn()),
          BallButton(onTap: () => context.read<GameProgressCubit>().makeSecondUserTurn()),
        ],
      );
}

class _UsernameInputs extends StatelessWidget {
  const _UsernameInputs();

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BlocSelector<UsernameInputCubit, UsernameForm, Username>(
              selector: (state) => state.firstUserName,
              builder: (context, state) => UsernameInput(
                updateName: (text) => context.read<UsernameInputCubit>().updateFirstUserName(text),
                pure: state.pure,
                error: state.error,
              ),
            ),
          ),
          const Gap(16),
          Expanded(
            child: BlocSelector<UsernameInputCubit, UsernameForm, Username>(
              selector: (state) => state.secondUserName,
              builder: (context, state) => UsernameInput(
                updateName: (text) => context.read<UsernameInputCubit>().updateSecondUserName(text),
                pure: state.pure,
                error: state.error,
              ),
            ),
          ),
        ],
      );
}

class _UsernameTexts extends StatelessWidget {
  const _UsernameTexts();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: BlocSelector<GameProgressCubit, GameProgressState, String>(
              selector: (state) => state.map(
                inactive: (value) => '',
                playing: (value) => value.firstUserName,
              ),
              builder: (context, state) => UsernameText(name: state),
            ),
          ),
          const Gap(16),
          Expanded(
            child: BlocSelector<GameProgressCubit, GameProgressState, String>(
              selector: (state) => state.map(
                inactive: (value) => '',
                playing: (value) => value.secondUserName,
              ),
              builder: (context, state) => UsernameText(name: state),
            ),
          ),
        ],
      );
}
