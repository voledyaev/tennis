import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game_page/game_page.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tennis',
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        home: const GamePage(),
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: child!,
        ),
      );
}
