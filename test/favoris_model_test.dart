import 'package:flutter_test/flutter_test.dart';
import 'package:tp3/models/destination.dart';
import 'package:tp3/providers/favoris_model.dart';

Destination _depuisApi() => Destination.fromJson({
      'id': 1,
      'nom': 'Djerba',
      'region': 'Médenine',
      'categorie': 'Plage',
      'image': 'assets/djerba.jpg',
      'note': 4.7,
      'prix': 450,
      'duree': '3 jours',
      'description': 'Île du sud.',
    });

void main() {
  test('les favoris sont conservés après un rafraîchissement', () {
    final model = FavorisModel();
    model.basculer(_depuisApi());

    // Le pull-to-refresh recrée de nouveaux objets Destination.
    final apresRefresh = _depuisApi();

    expect(model.estFavori(apresRefresh), isTrue);
    expect(model.nombre, 1);
  });
}
