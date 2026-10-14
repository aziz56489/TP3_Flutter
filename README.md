# tp3

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
## Questions de compréhension

**Q1.** Sans `Expanded`, l'avatar se place à côté de la `Column`. Parce que la `Row` organise les éléments horizontalement.

**Q2.** `prenom` est déclaré `final` parce que sa valeur ne change pas après l'initialisation.

**Q3.** `cs.primary` change selon la `seedColor` du thème, mais `Colors.teal` garde toujours la même couleur.

**Q4.** Si je place le `DecoratedBox` en premier, il apparaît derrière les autres éléments car les widgets sont affichés dans l'ordre de la liste.

**Q5.** Si je retire `ClipRRect`, l'image n'a plus les coins arrondis car ce widget permet de couper l'image avec des coins arrondis.

**Q6.** `right: 130` permet de placer les textes à 130 pixels du côté droit pour laisser de la place à l'avatar.

**Q7.** La `Column` doit être dans un `Expanded` pour prendre l'espace disponible. Comme ça, le `Spacer` peut utiliser l'espace restant dans la `Row` pour séparer la note et le prix.

**Q8.** Il faut ajouter une destination dans la liste des destinations, dans le fichier où cette liste est déclarée, probablement `home_screen.dart` ou le fichier qui contient les données des destinations.