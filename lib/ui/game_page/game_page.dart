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
                    child: Row(
                      children: [
                        Expanded(
                          child: _GameControls(
                            overallScoreSelector: (value) => value.firstUserOverallScore,
                            currentScoreSelector: (value) => value.firstUserCurrentScore,
                            onBallTap: () => context.read<GameProgressCubit>().makeFirstUserTurn(),
                          ),
                        ),
                        const Gap(32),
                        Expanded(
                          child: _GameControls(
                            overallScoreSelector: (value) => value.secondUserOverallScore,
                            currentScoreSelector: (value) => value.secondUserCurrentScore,
                            onBallTap: () => context.read<GameProgressCubit>().makeSecondUserTurn(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!state) const GamePauseOverlay(),
                  Padding(
                    padding: const EdgeInsets.all(32) + const EdgeInsets.only(top: 48),
                    child: Row(
                      children: [
                        Expanded(
                          child: _UsernameInteraction(
                            isEditable: state,
                            inputStateSelector: (state) => state.firstUserName,
                            updateName: (text) => context.read<UsernameInputCubit>().updateFirstUserName(text),
                            textStateSelector: (value) => value.firstUserName,
                          ),
                        ),
                        const Gap(32),
                        Expanded(
                          child: _UsernameInteraction(
                            isEditable: state,
                            inputStateSelector: (state) => state.secondUserName,
                            updateName: (text) => context.read<UsernameInputCubit>().updateSecondUserName(text),
                            textStateSelector: (value) => value.secondUserName,
                          ),
                        ),
                      ],
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

class _GameControls extends StatelessWidget {
  final int Function(GamePlaying value) overallScoreSelector;
  final String Function(GamePlaying value) currentScoreSelector;
  final VoidCallback onBallTap;

  const _GameControls({
    required this.overallScoreSelector,
    required this.currentScoreSelector,
    required this.onBallTap,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
              height: 246,
            ),
            BlocSelector<GameProgressCubit, GameProgressState, int>(
              selector: (state) => state.map(
                inactive: (value) => 0,
                playing: overallScoreSelector,
              ),
              builder: (context, state) => OverallScoreCounter(
                score: state.toString(),
              ),
            ),
            Positioned(
              top: 156,
              child: BlocSelector<GameProgressCubit, GameProgressState, String>(
                selector: (state) => state.map(
                  inactive: (value) => '0',
                  playing: currentScoreSelector,
                ),
                builder: (context, state) => CurrentScoreCounter(
                  score: state,
                ),
              ),
            ),
            Positioned(
              top: 182,
              child: BallButton(onTap: onBallTap),
            ),
          ],
        ),
      );
}

class _UsernameInteraction extends StatelessWidget {
  final bool isEditable;
  final Username Function(UsernameForm state) inputStateSelector;
  final void Function(String text) updateName;
  final String Function(GamePlaying value) textStateSelector;

  const _UsernameInteraction({
    required this.isEditable,
    required this.inputStateSelector,
    required this.updateName,
    required this.textStateSelector,
  });

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: !isEditable
            ? BlocSelector<UsernameInputCubit, UsernameForm, Username>(
                selector: inputStateSelector,
                builder: (context, state) => UsernameInput(
                  updateName: updateName,
                  pure: state.pure,
                  error: state.error,
                ),
              )
            : BlocSelector<GameProgressCubit, GameProgressState, String>(
                selector: (state) => state.map(
                  inactive: (value) => '',
                  playing: textStateSelector,
                ),
                builder: (context, state) => UsernameText(name: state),
              ),
      );
}
