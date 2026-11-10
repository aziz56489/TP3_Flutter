import 'package:flutter/material.dart';
import 'package:tp3/models/destination.dart';

import '../data/destinations.dart';
import '../services/api_service.dart';
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
  String _recherche = '';
  int _onglet = 0;
  final Set<String> _favoris = <String>{};
  late Future<List<Destination>> _futurDestinations;
  @override
  void initState() {
    super.initState();
    _futurDestinations = ApiService.getDestinations();
  }
  List<Destination> _filtrer(List<Destination> toutes) => _categorie =='Tout'
    ? toutes
    : toutes.where((d) => d.categorie == _categorie).toList();
  List<Destination> get _filtrees {
    final source = _onglet == 1
        ? destinations.where(
            (destination) => _favoris.contains(destination.nom),
          )
        : destinations;
    final query = _recherche.trim().toLowerCase();

    return source
        .where(
          (destination) =>
              _categorie == 'Tout' || destination.categorie == _categorie,
        )
        .where(
          (destination) =>
              query.isEmpty ||
              destination.nom.toLowerCase().contains(query) ||
              destination.region.toLowerCase().contains(query) ||
              destination.categorie.toLowerCase().contains(query),
        )
        .toList();
  }
  Future<void> _recharger() async{
    final futur = ApiService.getDestinations();
    setState(() {
      _futurDestinations = futur; 
    });
    try {
      await futur;
    }catch(_){}
  }
  Widget _construireExplorer(){
    return FutureBuilder<List<Destination>>(
      future: _futurDestinations,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child:CircularProgressIndicator());
        }
        if(snapshot.hasError){
          return ErreurReseau(message: "", onReessayer: _recharger);
        }
        final destinations = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _recharger,
          child: _construireAccueil(destinations));
      }
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
          SearchBox(onChanged: (value) => setState(() => _recherche = value)),
          const SizedBox(height: 24),
          HeroBanner(
            destination: destinations.first,
            isFavourite: _favoris.contains(destinations.first.nom),
            onFavouritePressed: () {
              setState(() {
                if (!_favoris.add(destinations.first.nom)) {
                  _favoris.remove(destinations.first.nom);
                }
              });
            },
          ),
          const SizedBox(height: 24),
          const SectionTitle(title: 'Catégories'),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final c in <String> {'Tout' , ...destinations.map((d)=>d.categorie)})
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
            DestinationCard(
              key: ValueKey(d.id),
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
          ?  _construireExplorer()
          :const Center(child: Text('Bientôt disponible')),
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
class ErreurReseau extends StatelessWidget{
  final String message;
  final VoidCallback onReessayer;
  const ErreurReseau({super.key, required this.message, required this.onReessayer});
  @override
  Widget build(BuildContext context) {
     return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_off,
          color: Theme.of(context).colorScheme.error,
          size: 60,
        ),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          "Verifier que json-server est lance",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(
          onPressed: onReessayer,
          icon : Icon(Icons.refresh),
          label: const Text("Reessayer")
        ),
      ],
     ); 
  }
}
