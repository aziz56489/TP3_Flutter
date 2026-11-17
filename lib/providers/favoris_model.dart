import 'package:flutter/foundation.dart';

import '../models/destination.dart';

/// TP6 — Partie 2.2 : favoris partagés par tous les écrans.
///
/// Laissez Copilot compléter les TODO UN PAR UN (Tab pour accepter,
/// Échap pour rejeter, Alt+] pour voir une autre proposition).
/// Avant d'accepter, vérifiez :
///   - la clé est d.id (et non d.nom) ;
///   - notifyListeners() est appelé dans basculer ;
///   - la liste exposée est en lecture seule (List.unmodifiable).
/// Notez chaque décision dans votre journal IA.
class FavorisModel extends ChangeNotifier {
  final Map<String, Destination> _favoris = {};

  bool estFavori(Destination d) => _favoris.containsKey(d.id);

  List<Destination> get liste => List.unmodifiable(_favoris.values);

  int get nombre => _favoris.length;
  bool basculer(Destination d) {
    final ajoute = _favoris.remove(d.id) == null;
    if (ajoute) _favoris[d.id] = d;
    notifyListeners();
    return ajoute;
  }
}
