import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp3/models/destination.dart';
import 'package:tp3/providers/favoris_model.dart';

class FavouriteButton extends StatelessWidget {
  final Destination destination;
  const FavouriteButton({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    //ligne generee par Copilot
    final estFavori = context.watch<FavorisModel>().estFavori(destination);

    return IconButton(
      tooltip: estFavori ? 'Retirer des favoris' : 'Ajouter aux favoris',
      onPressed: () => context.read<FavorisModel>().basculer(destination),
      icon: Icon(
        estFavori ? Icons.favorite : Icons.favorite_border,
        color: estFavori ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}
