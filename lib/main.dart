// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/di/injection_container.dart';
import 'presentation/viewmodels/feed_viewmodel.dart';
import 'presentation/views/feed_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await initDependencies();

  runApp(const ReelBoxApp());
}

class ReelBoxApp extends StatelessWidget {
  const ReelBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReelBox',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          secondary: Color(0xFFFF6584),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()},
        ),
      ),
      home: ChangeNotifierProvider<FeedViewModel>(
        create: (_) => sl<FeedViewModel>(),
        child: const FeedScreen(),
      ),
    );
  }
}
