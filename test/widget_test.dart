import 'package:flutter_test/flutter_test.dart';

import 'package:tp3/main.dart';

void main() {
  testWidgets('the home screen loads destinations and categories', (
    tester,
  ) async {
    await tester.pumpWidget(const RihlaApp());

    expect(find.text('Ahlan, Aziz 👋'), findsOneWidget);
    expect(find.text('Catégories'), findsOneWidget);
    expect(find.text('Sidi Bou Saïd'), findsOneWidget);
    expect(find.text('Djerba'), findsOneWidget);
  });

  testWidgets('the favorites tab filters the list', (tester) async {
    await tester.pumpWidget(const RihlaApp());

    await tester.tap(find.text('Favoris'));
    await tester.pumpAndSettle();

    expect(find.text('Mes favoris'), findsOneWidget);
  });
}
