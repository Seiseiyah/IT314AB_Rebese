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

  testWidgets('favorite action shows feedback', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Favorite').first);
    await tester.pump();
    expect(
      find.text('Added ${students.first.name} to favorites.'),
      findsOneWidget,
    );
    expect(find.text('Favorited'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('${students.first.name} card tapped.'), findsNothing);
  });

  testWidgets('favorite action toggles visible state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final firstCard = find.byType(StudentCard).first;

    expect(
      find.descendant(of: firstCard, matching: find.text('Favorite')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: firstCard,
        matching: find.byIcon(Icons.favorite_border),
      ),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(of: firstCard, matching: find.text('Favorite')),
    );
    await tester.pump();

    expect(
      find.descendant(of: firstCard, matching: find.text('Favorited')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: firstCard, matching: find.byIcon(Icons.favorite)),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(of: firstCard, matching: find.text('Favorited')),
    );
    await tester.pump();

    expect(
      find.descendant(of: firstCard, matching: find.text('Favorite')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: firstCard,
        matching: find.byIcon(Icons.favorite_border),
      ),
      findsOneWidget,
    );
  });

  testWidgets('favorite status is independent for each student', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final firstStudent = students.first;
    final secondStudent = students[1];
    final firstCard = find.byWidgetPredicate(
      (widget) =>
          widget is StudentCard &&
          widget.student.studentId == firstStudent.studentId,
    );
    final secondCard = find.byWidgetPredicate(
      (widget) =>
          widget is StudentCard &&
          widget.student.studentId == secondStudent.studentId,
    );
    Finder favoriteButton(Finder card) =>
        find.descendant(of: card, matching: find.text('Favorite'));
    Finder favoritedButton(Finder card) =>
        find.descendant(of: card, matching: find.text('Favorited'));

    await tester.ensureVisible(favoriteButton(firstCard));
    await tester.tap(favoriteButton(firstCard));
    await tester.pump();
    expect(favoritedButton(firstCard), findsOneWidget);

    await tester.ensureVisible(favoriteButton(secondCard));
    await tester.tap(favoriteButton(secondCard));
    await tester.pump();
    expect(favoritedButton(secondCard), findsOneWidget);

    await tester.scrollUntilVisible(
      favoritedButton(firstCard),
      -500,
      scrollable: find.byType(Scrollable),
    );
    expect(favoritedButton(firstCard), findsOneWidget);
    await tester.scrollUntilVisible(
      favoritedButton(secondCard),
      500,
      scrollable: find.byType(Scrollable),
    );
    expect(favoritedButton(secondCard), findsOneWidget);
  });

  testWidgets('deleting a student removes its card and closes the gap', (
    WidgetTester tester,
  ) async {
    final originalStudents = List<Student>.from(students);
    addTearDown(() {
      students
        ..clear()
        ..addAll(originalStudents);
    });

    await tester.pumpWidget(const MyApp());
    final studentToDelete = students[1];
    final expectedRemaining = [
      ...students.take(1),
      ...students.skip(2),
    ].map((student) => student.name).toList();
    final cardToDelete = find.byWidgetPredicate(
      (widget) =>
          widget is StudentCard &&
          widget.student.studentId == studentToDelete.studentId,
    );
    final deleteButton = find.descendant(
      of: cardToDelete,
      matching: find.text('Delete'),
    );
    await tester.ensureVisible(deleteButton);
    await tester.pumpAndSettle();
    await tester.tap(deleteButton);
    await tester.pump();

    expect(students.map((student) => student.name).toList(), expectedRemaining);
    expect(find.text(studentToDelete.name), findsNothing);
    expect(find.text('${students.length} Students'), findsOneWidget);
  });

  testWidgets('favorite, delete, and edit actions stay independent', (
    WidgetTester tester,
  ) async {
    final originalStudents = List<Student>.from(students);
    addTearDown(() {
      students
        ..clear()
        ..addAll(originalStudents);
    });

    await tester.pumpWidget(const MyApp());
    final favoriteStudent = students[0];
    final editStudent = students[1];
    final deletedStudent = students[2];

    Finder cardFor(Student student) => find.byWidgetPredicate(
      (widget) =>
          widget is StudentCard &&
          widget.student.studentId == student.studentId,
    );
    Finder buttonOnCard(Student student, String label) =>
        find.descendant(of: cardFor(student), matching: find.text(label));
    Future<void> showCardButton(
      Student student,
      String label,
      double scrollDelta,
    ) async {
      final button = buttonOnCard(student, label);
      await tester.scrollUntilVisible(
        button,
        scrollDelta,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();
    }

    Future<void> tapCardButton(
      Student student,
      String label,
      double scrollDelta,
    ) async {
      await showCardButton(student, label, scrollDelta);
      final button = buttonOnCard(student, label);
      await tester.tap(button);
      await tester.pumpAndSettle();
    }

    await tapCardButton(favoriteStudent, 'Favorite', -500);
    expect(buttonOnCard(favoriteStudent, 'Favorited'), findsOneWidget);

    await showCardButton(editStudent, 'Favorite', 500);
    expect(buttonOnCard(editStudent, 'Favorite'), findsOneWidget);

    await tapCardButton(deletedStudent, 'Delete', 500);
    expect(
      students.any((student) => student.studentId == deletedStudent.studentId),
      isFalse,
    );
    expect(cardFor(deletedStudent), findsNothing);

    await showCardButton(favoriteStudent, 'Favorited', -500);
    expect(buttonOnCard(favoriteStudent, 'Favorited'), findsOneWidget);

    await showCardButton(editStudent, 'Favorite', 500);
    expect(buttonOnCard(editStudent, 'Favorite'), findsOneWidget);

    await tapCardButton(editStudent, 'Edit', 500);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Edit ${editStudent.name}'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);

    await showCardButton(favoriteStudent, 'Favorited', -500);
    expect(buttonOnCard(favoriteStudent, 'Favorited'), findsOneWidget);

    await showCardButton(editStudent, 'Favorite', 500);
    expect(buttonOnCard(editStudent, 'Favorite'), findsOneWidget);
  });

  testWidgets('edit action opens a dismissible dialog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Edit').first);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Edit ${students.first.name}'), findsOneWidget);
    expect(
      find.text('Student editing is ready for the next step.'),
      findsOneWidget,
    );
    expect(find.text('${students.first.name} card tapped.'), findsNothing);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('tapping the student card shows separate feedback', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text(students.first.name));
    await tester.pump();

    expect(find.text('${students.first.name} card tapped.'), findsOneWidget);
  });
}
