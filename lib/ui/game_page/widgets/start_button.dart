import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../logic/game_progress_cubit.dart';
import '../../../logic/username_input_cubit.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<UsernameInputCubit, UsernameForm>(
        builder: (context, state) => ElevatedButton(
          onPressed: state.status == FormzStatus.valid
              ? () {
                  context.read<UsernameInputCubit>().reset();
                  context.read<GameProgressCubit>().startGame(
                        firstUserName: state.firstUserName.value,
                        secondUserName: state.secondUserName.value,
                      );
                }
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          ),
          child: Text(
            'START',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      );
}
