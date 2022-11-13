import 'dart:ui';

import 'package:flutter/material.dart';

class GamePauseOverlay extends StatelessWidget {
  const GamePauseOverlay({super.key});

  @override
  Widget build(BuildContext context) => AbsorbPointer(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: const SizedBox.expand(),
        ),
      );
}
