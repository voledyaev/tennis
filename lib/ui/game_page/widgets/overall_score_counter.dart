import 'package:flutter/material.dart';

class OverallScoreCounter extends StatelessWidget {
  final String score;

  const OverallScoreCounter({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) => Text(
        score,
        style: Theme.of(context).textTheme.headline5,
      );
}
