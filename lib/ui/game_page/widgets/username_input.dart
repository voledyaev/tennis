import 'package:flutter/material.dart';

class UsernameInput extends StatefulWidget {
  final void Function(String text) updateName;
  final bool pure;
  final String? error;

  const UsernameInput({
    super.key,
    required this.updateName,
    required this.pure,
    this.error,
  });

  @override
  State<UsernameInput> createState() => _UsernameInputState();
}

class _UsernameInputState extends State<UsernameInput> {
  final _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.addListener(() => widget.updateName(_controller.text));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: !widget.pure ? Colors.green : Theme.of(context).colorScheme.primary),
    );

    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Surname Name',
        errorText: !widget.pure ? widget.error : null,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(borderSide: border.borderSide.copyWith(width: 2)),
      ),
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.center,
    );
  }
}
