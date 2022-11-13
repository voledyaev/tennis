import 'package:flutter/material.dart';

class UsernameText extends StatelessWidget {
  final String name;

  const UsernameText({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) => Text(
        name,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      );
}
