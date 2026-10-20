import 'package:flutter/material.dart';
import 'package:tp3/models/destination.dart';

import '../data/destinations.dart';
import '../widgets/destination_card.dart';
import '../widgets/hero_banner.dart';
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _categorie = 'Tout';
  int _onglet = 0;
  final Set<String> _favoris = <String>{};

  List<Destination> get _filtrees {
    if (_categorie == 'Tout') {
      return destinations.take(6).toList();
    }

    return destinations
        .where((destination) => destination.categorie == _categorie)
        .toList();
  }

  Widget _construireAccueil() {
    return SafeArea(
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
                for (final c in categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: _categorie == c,
                      onSelected: (_) {
                        setState(() => _categorie = c);
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle(title: 'Populaires', action: 'Voir tout'),
          const SizedBox(height: 12),
          // Une clé stable garde l'état visuel associé à la bonne destination lors du filtrage.
          for (final d in _filtrees)
            DestinationCard(
              key: ValueKey(d.nom),
              destination: d,
              isFavourite: _favoris.contains(d.nom),
              onFavouritePressed: () {
                setState(() {
                  if (!_favoris.add(d.nom)) _favoris.remove(d.nom);
                });
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _onglet == 0
          ? _construireAccueil()
          : const Center(child: Text('Bientôt disponible')),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,
        onDestinationSelected: (index) {
          setState(() => _onglet = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
