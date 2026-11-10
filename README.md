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


### Q1. 
Oui, le filtre est conservé. Lorsque l'on ouvre une destination via `Navigator.push`, Flutter empile une nouvelle route au-dessus de l'écran d'accueil. La page d'accueil reste dans la pile en dessous. Quand on revient avec `Navigator.pop`, Flutter retire la route du dessus (principe LIFO : Last In, First Out). La route précédente, qui contient le filtre, reste vivante avec son état local, donc le filtre « Désert » est toujours appliqué. Ici, la notion de pile correspond à la pile de routes navigables : la route active est au-dessus, puis on la retire pour retrouver la précédente.

### Q2.
`DetailScreen` reçoit la destination via son constructeur. La destination est donc transmise depuis l'écran source vers l'écran destination, exactement comme dans le TP 3 où l'on passait des données entre écrans en utilisant le constructeur ou les paramètres de route. On réutilise le mécanisme de navigation avec données : un objet de modèle (`Destination`) est envoyé à la nouvelle page avant son affichage.

### Q3. 
Quand on retire `clipBehavior`, l'effet visuel de pression (`InkWell` / ripple) n'est plus coupé par les bords arrondis de la carte. On remarque alors que le splash semble sortir au-delà du contour arrondi et que le rendu devient moins propre. `clipBehavior` sert donc à contenir l'effet au sein du widget et à préserver la forme arrondie.

## Questions de compréhension sur le formulaire de réservation

### Q1. Que fait exactement `_formKey.currentState!.validate()` ? Que renvoie-t-elle ?
`_formKey.currentState` donne l'état du formulaire associé à la clé. Ensuite, `validate()` appelle la méthode `validate()` de chaque `FormField` du formulaire (ici les `TextFormField`). Chaque champ exécute alors son `validator`. Si tous les champs sont valides, `validate()` renvoie `true`. Si au moins un champ est invalide, il renvoie `false` et affiche les messages d'erreur correspondants. Donc cette instruction sert à valider le formulaire entier et à renvoyer un booléen.

### Q2. `inputFormatters` et `validator` contrôlent tous deux le téléphone. Quelle est la différence de rôle ?
Le `validator` vérifie la validité du contenu au moment de la validation du formulaire : il contrôle le format logique (par exemple 8 chiffres, champ obligatoire, etc.). En revanche, `inputFormatters` agit au niveau de l'entrée utilisateur, avant validation : il limite ou transforme ce que l'utilisateur peut taper, par exemple en autorisant uniquement des chiffres, en supprimant les espaces ou en imposant une longueur maximale. En résumé :
- `validator` = vérifie le sens / la validité du champ
- `inputFormatters` = limite la saisie au clavier et au texte saisi

### Q3. Pourquoi faut-il appeler `dispose()` sur les contrôleurs ?
Parce que les `TextEditingController` gardent en mémoire l'état du champ de texte (contenu actuel, curseur, etc.). Si on ne les libère pas quand l'écran est détruit, on laisse des ressources inutilisées et on peut provoquer des fuites mémoire. `dispose()` permet de nettoyer correctement les contrôleurs et d'éviter de conserver de l'état d'un widget qui n'existe plus. C'est la bonne pratique dans Flutter pour libérer les ressources et éviter les bugs de mémoire.

## Questions de compréhension sur la réservation

### Q1. Pourquoi le champ date est-il en `readOnly` ? Que se passerait-il sinon ?
Il est en `readOnly` pour choisir la date avec le calendrier, pas avec le clavier. Sinon, on pourrait taper une date au mauvais format.

### Q2. `_total` est un getter. Pourquoi n'a-t-on pas besoin de le mettre à jour nous-mêmes quand la formule change ?
Le getter recalcule le total à partir de la formule et du nombre de voyageurs. Quand la formule change, `setState` reconstruit l'écran et le getter donne le nouveau total.

## Questions sur la réservation et la boîte de dialogue

### Q1. Que vaut `reservation` si l'utilisateur quitte le formulaire avec la flèche retour ?
Elle vaut `null`, car aucune réservation n'a été renvoyée avec `Navigator.pop`.

### Q2. Que signifie l'avertissement si on retire le test `mounted` ?
VS Code signale qu'on utilise `BuildContext` après un `await` sans vérifier que le widget existe encore. `mounted` évite d'utiliser un contexte dont l'écran a été fermé.

### Q3. Que nous apprend le bouton « Parfait » sur les boîtes de dialogue ?
Une boîte de dialogue est aussi une route dans la pile de navigation. `Navigator.pop` la ferme et revient à l'écran qui l'a ouverte.

### Palier0/Q1 . erreur 404 sous format json , ERREUR DE CLIENT
### Q2. le serveur
### Q3 . La requete sert a recuperer des donnees ces informations sont generalement transmis dans l Url , tandis que la requete POST sert a envoyer des informations
