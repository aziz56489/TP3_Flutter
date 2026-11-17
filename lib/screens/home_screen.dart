import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp3/models/destination.dart';

import '../providers/favoris_model.dart';
import '../services/api_service.dart';
import '../widgets/destination_card.dart';
import '../widgets/hero_banner.dart';
import '../widgets/home_header.dart';
import '../widgets/search_box.dart';
import '../widgets/section_title.dart';
import 'favoris_screen.dart';
import 'mes_reservations_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class ErreurReseau extends StatelessWidget {
  const ErreurReseau({
    super.key,
    required this.message,
    required this.onReessayer,
  });

  final String message;
  final VoidCallback onReessayer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              color: Theme.of(context).colorScheme.error,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text(
              'Vérifiez que json-server est lancé',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onReessayer,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String _categorie = 'Tout';
  int _onglet = 0;
  late Future<List<Destination>> _futurDestinations;
  @override
  void initState() {
    super.initState();
    _futurDestinations = ApiService.getDestinations();
  }

  List<Destination> _filtrer(List<Destination> toutes) => _categorie == 'Tout'
      ? toutes
      : toutes.where((d) => d.categorie == _categorie).toList();
  Future<void> _recharger() async {
    final futur = ApiService.getDestinations();
    setState(() {
      _futurDestinations = futur;
    });
    try {
      await futur;
    } catch (_) {}
  }

  Widget _construireExplorer() {
    return FutureBuilder<List<Destination>>(
      future: _futurDestinations,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return ErreurReseau(message: "", onReessayer: _recharger);
        }
        final destinations = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _recharger,
          child: _construireAccueil(destinations),
        );
      },
    );
  }

  Widget _construireAccueil(List<Destination> destinations) {
    final filtrees = _filtrer(destinations);
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
                for (final c in <String>{
                  'Tout',
                  ...destinations.map((d) => d.categorie),
                })
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
          SectionTitle(title: _onglet == 1 ? 'Mes favoris' : 'Populaires'),
          const SizedBox(height: 12),
          // Une clé stable garde l'état visuel associé à la bonne destination lors du filtrage.
          for (final d in filtrees)
            DestinationCard(key: ValueKey(d.id), destination: d),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nbFavoris = context.watch<FavorisModel>().nombre;
    return Scaffold(
      body: switch (_onglet) {
        0 => _construireExplorer(),
        1 => const FavorisScreen(),
        _ => const MesReservationsScreen(),
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _onglet,
        onDestinationSelected: (index) {
          setState(() => _onglet = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: nbFavoris > 0,
              label: Text('$nbFavoris'),
              child: const Icon(Icons.favorite_border),
            ),
            selectedIcon: Badge(
              isLabelVisible: nbFavoris > 0,
              label: Text('$nbFavoris'),
              child: const Icon(Icons.favorite),
            ),
            label: 'Favoris',
          ),
          const NavigationDestination(
            icon: Icon(Icons.luggage_outlined),
            selectedIcon: Icon(Icons.luggage),
            label: 'Mes Voyages',
          ),
        ],
      ),
    );
  }
}
