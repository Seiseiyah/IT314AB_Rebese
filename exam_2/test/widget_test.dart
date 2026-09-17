import 'package:flutter_test/flutter_test.dart';

import 'package:exam_2/main.dart';

void main() {
  testWidgets('friend list shows and responds to interactions', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Social'), findsOneWidget);
    expect(find.text('MissYouLikeKrazy'), findsOneWidget);

    await tester.tap(find.text('MissYouLikeKrazy'));
    await tester.pumpAndSettle();

    expect(find.text('Conversation with MissYouLikeKrazy'), findsOneWidget);
    expect(find.text('Mark as read'), findsOneWidget);

    await tester.tap(find.text('Mark as read'));
    await tester.pump();

    expect(find.text('Read'), findsOneWidget);
  });
}
