import 'package:flutter/material.dart';

import '../data/destinations.dart';
import '../widgets/hero_banner.dart';
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const HomeHeader(prenom: 'Aziz'),
            const SizedBox(height: 20),
            const SearchBox(),
            const SizedBox(height: 24),
            HeroBanner(destination: destinations.first),
          ],
        ),
      ),
    );
  }
}
