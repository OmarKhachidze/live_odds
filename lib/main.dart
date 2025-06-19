import 'package:flutter/material.dart';
import 'package:live_odds/presentation/providers/matches_provider.dart';
import 'package:live_odds/presentation/screens/matches_screen.dart';
import 'package:provider/provider.dart';

import 'data/repository/odds_repository_impl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => OddsProvider(ImplOddsRepository()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MatchesScreen(),
    );
  }
}
