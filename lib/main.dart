import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp3/providers/favoris_model.dart';
import 'package:tp3/providers/reglages_model.dart';

import 'screens/home_screen.dart';

const Color graine = Color(0xFF0E7C86);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavorisModel()..charger()),
        ChangeNotifierProvider(create: (_) => ReglagesModel()..charger()),
      ],
      child: const RihlaApp(),
    ),
  );
}

class RihlaApp extends StatelessWidget {
  const RihlaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rihla',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: graine),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: graine,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: context.watch<ReglagesModel>().sombre ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
