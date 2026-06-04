import 'package:flutter_test/flutter_test.dart';

import 'package:team_collab_lab/main.dart';

void main() {
  testWidgets('shows the three collaboration areas', (tester) async {
    await tester.pumpWidget(const TeamCollabApp());

    expect(find.text('Hello World Lab'), findsOneWidget);
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Tetris'), findsOneWidget);
    expect(find.text('Logs'), findsOneWidget);
    expect(find.text('赵林超'), findsOneWidget);
  });
}
