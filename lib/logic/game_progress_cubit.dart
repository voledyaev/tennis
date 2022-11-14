import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_progress_cubit.freezed.dart';

class GameProgressCubit extends Cubit<GameProgressState> {
  final Future<void> Function(String result) showGameResultDialog;

  GameProgressCubit({
    required this.showGameResultDialog,
  }) : super(const GameProgressState.inactive());

  void startGame({
    required String firstUserName,
    required String secondUserName,
  }) =>
      emit(
        GameProgressState.playing(
          firstUserName: firstUserName,
          secondUserName: secondUserName,
        ),
      );

  Future<void> makeFirstUserTurn() async {
    final prevState = state.map(
      inactive: (value) => throw UnimplementedError(),
      playing: (value) => value,
    );

    var nextState = prevState;

    if (nextState.firstUserCurrentScore == 'A') {
      nextState = nextState.copyWith(
        firstUserOverallScore: nextState.firstUserOverallScore + 1,
        firstUserCurrentScore: '0',
        secondUserCurrentScore: '0',
      );
    } else if (nextState.firstUserCurrentScore == '40' && nextState.secondUserCurrentScore == '40') {
      nextState = nextState.copyWith(
        firstUserCurrentScore: 'A',
      );
    } else if (nextState.secondUserCurrentScore == 'A') {
      nextState = nextState.copyWith(
        secondUserCurrentScore: '40',
      );
    } else if (nextState.firstUserCurrentScore == '40') {
      nextState = nextState.copyWith(
        firstUserOverallScore: nextState.firstUserOverallScore + 1,
        firstUserCurrentScore: '0',
        secondUserCurrentScore: '0',
      );
    } else {
      nextState = nextState.copyWith(
        firstUserCurrentScore: nextState.firstUserCurrentScore.incrementScore(),
      );
    }

    emit(nextState);

    _checkGameResult(nextState);
  }

  Future<void> makeSecondUserTurn() async {
    final prevState = state.map(
      inactive: (value) => throw UnimplementedError(),
      playing: (value) => value,
    );

    var nextState = prevState;

    if (nextState.secondUserCurrentScore == 'A') {
      nextState = nextState.copyWith(
        secondUserOverallScore: nextState.secondUserOverallScore + 1,
        secondUserCurrentScore: '0',
        firstUserCurrentScore: '0',
      );
    } else if (nextState.secondUserCurrentScore == '40' && nextState.firstUserCurrentScore == '40') {
      nextState = nextState.copyWith(
        secondUserCurrentScore: 'A',
      );
    } else if (nextState.firstUserCurrentScore == 'A') {
      nextState = nextState.copyWith(
        firstUserCurrentScore: '40',
      );
    } else if (nextState.secondUserCurrentScore == '40') {
      nextState = nextState.copyWith(
        secondUserOverallScore: nextState.secondUserOverallScore + 1,
        secondUserCurrentScore: '0',
        firstUserCurrentScore: '0',
      );
    } else {
      nextState = nextState.copyWith(
        secondUserCurrentScore: nextState.secondUserCurrentScore.incrementScore(),
      );
    }

    emit(nextState);

    _checkGameResult(nextState);
  }

  void reset() => emit(const GameProgressState.inactive());

  Future<void> _checkGameResult(GamePlaying nextState) async {
    String? winner;

    if (nextState.firstUserOverallScore >= 6 &&
        nextState.firstUserOverallScore - nextState.secondUserOverallScore >= 2) {
      winner = nextState.firstUserName;
    } else if (nextState.secondUserOverallScore >= 6 &&
        nextState.secondUserOverallScore - nextState.firstUserOverallScore >= 2) {
      winner = nextState.secondUserName;
    }

    if (winner != null) {
      await showGameResultDialog('$winner won!');

      emit(const GameProgressState.inactive());
    }
  }
}

@freezed
class GameProgressState with _$GameProgressState {
  const factory GameProgressState.inactive() = GameInactive;

  const factory GameProgressState.playing({
    required String firstUserName,
    required String secondUserName,
    @Default(0) int firstUserOverallScore,
    @Default(0) int secondUserOverallScore,
    @Default('0') String firstUserCurrentScore,
    @Default('0') String secondUserCurrentScore,
  }) = GamePlaying;
}

extension on String {
  String incrementScore() {
    switch (this) {
      case '0':
        return '15';
      case '15':
        return '30';
      case '30':
        return '40';
      default:
        throw UnimplementedError();
    }
  }
}
