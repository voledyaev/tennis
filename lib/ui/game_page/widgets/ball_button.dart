import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BallButton extends StatelessWidget {
  final VoidCallback onTap;

  const BallButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: FaIcon(
            FontAwesomeIcons.baseball,
            size: 32,
          ),
        ),
      );
}
