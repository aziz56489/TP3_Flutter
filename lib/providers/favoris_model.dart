import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
  static const _cle = 'favoris';
  final Map<String, Destination> _favoris = {};
  bool estFavori(Destination d) => _favoris.containsKey(d.id);
  List<Destination> get liste => List.unmodifiable(_favoris.values);
  int get nombre => _favoris.length;
  bool basculer(Destination d) {
    final ajoute = _favoris.remove(d.id) == null;
    if(ajoute) _favoris[d.id] = d;
    _sauvegarder();
    notifyListeners();
    return ajoute;
  }
  Future<void> charger() async{
    final prefs = await SharedPreferences.getInstance();
    final List<String> textes = prefs.getStringList(_cle) ?? <String>[];
    for (final t in textes){
      final json = jsonDecode(t) as Map<String,dynamic>;
      final d = Destination.fromJson(json);
      _favoris[d.id] = d;
    }
    notifyListeners();
  }
  Future<void> _sauvegarder() async{
    final prefs = await SharedPreferences.getInstance();
    final textes = _favoris.values.map((Destination)=>jsonEncode(Destination.toJson())).toList();
    await prefs.setStringList(_cle, textes);
  }
}