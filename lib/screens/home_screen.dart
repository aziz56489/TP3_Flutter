import 'package:flutter/material.dart';

import '../data/destinations.dart';
import '../widgets/destination_card.dart';
import '../widgets/hero_banner.dart';
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/section_title.dart';

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
            const SizedBox(height: 24),
            const SectionTitle(title: 'Catégories'),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final category in categories)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: category == 'Tout',
                        onSelected: (_) {},
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionTitle(
              title: 'Populaires',
              action: 'Voir tout',
            ),
            const SizedBox(height: 12),
            for (final destination in destinations)
              DestinationCard(destination: destination),
          ],
        ),
      ),
    );
  }
}
