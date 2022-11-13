import 'package:flutter/material.dart';

class CurrentScoreCounter extends StatelessWidget {
  final String score;

  const CurrentScoreCounter({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) => Text(
        score,
        style: Theme.of(context).textTheme.headline6,
      );
}
