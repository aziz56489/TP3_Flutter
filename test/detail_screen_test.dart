import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tp3/data/destinations.dart';
import 'package:tp3/providers/favoris_model.dart';
import 'package:tp3/screens/detail_screen.dart';

void main() {
  testWidgets('detail favorite button toggles shared favorite state', (
    tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FavorisModel(),
        child: MaterialApp(
          home: DetailScreen(destination: destinations.first),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);

    await tester.tap(find.byTooltip('Ajouter aux favoris'));
    await tester.pump();

    expect(find.byIcon(Icons.favorite_border), findsNothing);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
