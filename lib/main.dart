import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui/application.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const Application());
}
