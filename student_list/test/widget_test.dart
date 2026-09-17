// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:student_list/main.dart';

void main() {
  testWidgets('renders sorted students with generated cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Aaron Cruz'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Maria Santos'),
      500,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Maria Santos'), findsOneWidget);
  });

  testWidgets('shows an empty state when there are no students', (
    WidgetTester tester,
  ) async {
    final originalStudents = List<Student>.from(students);
    students.clear();

    await tester.pumpWidget(const MyApp());

    expect(find.text('No students found.'), findsOneWidget);
    expect(find.byType(StudentCard), findsNothing);

    students
      ..clear()
      ..addAll(originalStudents);
  });
}
