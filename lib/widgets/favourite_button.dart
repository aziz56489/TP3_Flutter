import 'package:flutter/material.dart';

class FavouriteButton extends StatelessWidget {
  final bool isFavourite;
  final VoidCallback onPressed;

  const FavouriteButton({
    super.key,
    required this.isFavourite,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isFavourite ? 'Retirer des favoris' : 'Ajouter aux favoris',
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      icon: Icon(
        isFavourite ? Icons.favorite : Icons.favorite_border,
        color: isFavourite ? Colors.red : null,
      ),
    );
  }
}
