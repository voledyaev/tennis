import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'username_input_cubit.freezed.dart';

class UsernameInputCubit extends Cubit<UsernameForm> {
  UsernameInputCubit() : super(const UsernameForm());

  void updateFirstUserName(String value) =>
      emit(state.copyWith(firstUserName: value.isEmpty ? const Username.pure() : Username.dirty(value: value)));

  void updateSecondUserName(String value) =>
      emit(state.copyWith(secondUserName: value.isEmpty ? const Username.pure() : Username.dirty(value: value)));

  void reset() => emit(const UsernameForm());
}

@freezed
class UsernameForm with _$UsernameForm, FormzMixin {
  const factory UsernameForm({
    @Default(Username.pure()) Username firstUserName,
    @Default(Username.pure()) Username secondUserName,
  }) = _UsernameForm;

  const UsernameForm._();

  @override
  List<FormzInput<String, String>> get inputs => [firstUserName, secondUserName];
}

class Username extends FormzInput<String, String> {
  const Username.pure() : super.pure('');

  const Username.dirty({String value = ''}) : super.dirty(value);

  @override
  String? validator(String value) {
    if (!RegExp(r'^[A-Z]{1,}\s[A-Z]{1,}$').hasMatch(value)) return 'Incorrect name';

    return null;
  }
}
