import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tp3/data/destinations.dart';
import 'package:tp3/screens/detail_screen.dart';

void main() {
  testWidgets('detail favorite button toggles and notifies its owner', (
    tester,
  ) async {
    var favoriteChanges = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: DetailScreen(
          destination: destinations.first,
          isFavourite: false,
          onFavouritePressed: () => favoriteChanges++,
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);

    await tester.tap(find.byTooltip('Ajouter aux favoris'));
    await tester.pump();

    expect(find.byIcon(Icons.favorite_border), findsNothing);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(favoriteChanges, 1);
  });
}
