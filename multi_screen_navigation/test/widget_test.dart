// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:student_list/main.dart';

Future<void> _pumpLoadedDirectory(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  testWidgets('shows loading state before displaying students', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(StudentListScreen), findsOneWidget);
    expect(
      ModalRoute.of(
        tester.element(find.byType(StudentListScreen)),
      )?.settings.name,
      StudentListScreen.routeName,
    );
    expect(find.text('Student Directory'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading students...'), findsOneWidget);
    expect(find.byType(StudentCard), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.text('No students found.'), findsNothing);

    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(StudentCard), findsWidgets);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('No students found.'), findsNothing);
  });

  testWidgets('shows empty state after loading an empty directory', (
    WidgetTester tester,
  ) async {
    final originalStudents = List<Student>.from(students);
    addTearDown(() {
      students
        ..clear()
        ..addAll(originalStudents);
    });
    students.clear();

    await tester.pumpWidget(const MyApp());

    expect(find.text('Loading students...'), findsOneWidget);
    expect(find.text('No students found.'), findsNothing);
    expect(find.byType(ListView), findsNothing);

    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Loading students...'), findsNothing);
    expect(find.text('No students found.'), findsOneWidget);
    expect(find.byType(StudentCard), findsNothing);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('shows active and inactive status on student cards', (
    WidgetTester tester,
  ) async {
    await _pumpLoadedDirectory(tester);

    final activeCard = find
        .byWidgetPredicate(
          (widget) => widget is StudentCard && widget.student.isActive,
        )
        .first;
    final inactiveCard = find
        .byWidgetPredicate(
          (widget) => widget is StudentCard && !widget.student.isActive,
        )
        .first;

    expect(
      find.descendant(of: activeCard, matching: find.text('Active')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: inactiveCard, matching: find.text('Inactive')),
      findsOneWidget,
    );
  });

  testWidgets('renders sorted students with generated cards', (
    WidgetTester tester,
  ) async {
    await _pumpLoadedDirectory(tester);

    final actualStudentNames = students.map((student) => student.name).toList();
    final sortedStudentNames = [...actualStudentNames]..sort();

    expect(actualStudentNames, sortedStudentNames);
    expect(find.text(students.first.name), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text(students.last.name),
      500,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text(students.last.name), findsOneWidget);
  });

  testWidgets('shows empty state after deleting every student', (
    WidgetTester tester,
  ) async {
    final originalStudents = List<Student>.from(students);
    addTearDown(() {
      students
        ..clear()
        ..addAll(originalStudents);
    });

    await _pumpLoadedDirectory(tester);

    while (students.isNotEmpty) {
      final deleteButton = find.descendant(
        of: find.byType(StudentCard).first,
        matching: find.text('Delete'),
      );
      await tester.ensureVisible(deleteButton);
      await tester.tap(deleteButton);
      await tester.pump();
    }

    expect(find.text('No students found.'), findsOneWidget);
    expect(
      find.text('There are no students in the directory yet.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.people_outline), findsOneWidget);
    expect(find.byType(StudentCard), findsNothing);
    expect(find.byType(ListView), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('favorite action shows feedback', (WidgetTester tester) async {
    await _pumpLoadedDirectory(tester);

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
    await _pumpLoadedDirectory(tester);
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
    expect(
      find.descendant(of: firstCard, matching: find.text('Favorite student')),
      findsNothing,
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
    expect(
      find.descendant(of: firstCard, matching: find.text('Favorite student')),
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
    expect(
      find.descendant(of: firstCard, matching: find.text('Favorite student')),
      findsNothing,
    );
  });

  testWidgets('favorite status is independent for each student', (
    WidgetTester tester,
  ) async {
    await _pumpLoadedDirectory(tester);
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

    await _pumpLoadedDirectory(tester);
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

  testWidgets('details edit dialog prepopulates and saves selected student', (
    WidgetTester tester,
  ) async {
    final originalStudents = List<Student>.from(students);
    addTearDown(() {
      students
        ..clear()
        ..addAll(originalStudents);
    });

    await _pumpLoadedDirectory(tester);
    final selectedStudent = students.first;
    await tester.tap(find.text(selectedStudent.name));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Edit Student'), findsOneWidget);
    expect(
      ModalRoute.of(
        tester.element(find.byType(StudentDetailsScreen)),
      )?.settings.name,
      StudentDetailsScreen.routeName,
    );
    expect(
      ModalRoute.of(tester.element(find.byType(AlertDialog)))?.settings.name,
      isNull,
    );
    TextFormField field(String key) =>
        tester.widget<TextFormField>(find.byKey(ValueKey(key)));
    expect(field('student-name').controller!.text, selectedStudent.name);
    expect(field('student-id').controller!.text, selectedStudent.studentId);
    expect(field('student-course').controller!.text, selectedStudent.course);
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      selectedStudent.isActive,
    );

    await tester.enterText(find.byKey(const ValueKey('student-age')), 'abc');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid age.'), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('student-age')),
      '${selectedStudent.age}',
    );

    const updatedName = 'Zed Updated';
    await tester.enterText(
      find.byKey(const ValueKey('student-name')),
      updatedName,
    );
    await tester.ensureVisible(find.byType(SwitchListTile));
    await tester.tap(find.byType(SwitchListTile));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(
      find.descendant(
        of: find.byType(StudentDetailsScreen),
        matching: find.text(updatedName),
      ),
      findsOneWidget,
    );
    final updatedStudent = students.firstWhere(
      (student) => student.studentId == selectedStudent.studentId,
    );
    expect(updatedStudent.name, updatedName);
    expect(updatedStudent.isActive, !selectedStudent.isActive);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text(updatedName),
      500,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text(updatedName), findsOneWidget);
  });

  testWidgets('selected student details match and back returns to list', (
    WidgetTester tester,
  ) async {
    await _pumpLoadedDirectory(tester);

    for (final selectedStudent in students.take(2)) {
      await tester.ensureVisible(find.text(selectedStudent.name));
      await tester.tap(find.text(selectedStudent.name));
      await tester.pumpAndSettle();

      final detailsScreen = find.byType(StudentDetailsScreen);
      expect(detailsScreen, findsOneWidget);
      final detailsRoute = ModalRoute.of(tester.element(detailsScreen))!;
      expect(detailsRoute.settings.name, StudentDetailsScreen.routeName);
      expect(
        detailsRoute.settings.arguments,
        isA<StudentDetailsRouteArguments>(),
      );
      expect(
        (detailsRoute.settings.arguments as StudentDetailsRouteArguments)
            .student
            .studentId,
        selectedStudent.studentId,
      );
      expect(
        find.descendant(
          of: detailsScreen,
          matching: find.text(selectedStudent.name),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: detailsScreen,
          matching: find.text(selectedStudent.studentId),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: detailsScreen,
          matching: find.text(selectedStudent.course),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: detailsScreen,
          matching: find.text(selectedStudent.isActive ? 'Active' : 'Inactive'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      expect(find.byType(StudentDetailsScreen), findsNothing);
      expect(find.byType(StudentListScreen), findsOneWidget);
      expect(find.text('Student Directory'), findsOneWidget);
    }
  });

  testWidgets('Add Student action opens its screen and back returns to list', (
    WidgetTester tester,
  ) async {
    await _pumpLoadedDirectory(tester);

    await tester.tap(find.byTooltip('Add Student'));
    await tester.pumpAndSettle();

    final addStudentScreen = find.byType(AddStudentScreen);
    expect(addStudentScreen, findsOneWidget);
    expect(
      ModalRoute.of(tester.element(addStudentScreen))?.settings.name,
      AddStudentScreen.routeName,
    );
    expect(find.text('Add Student'), findsOneWidget);
    expect(
      find.descendant(of: addStudentScreen, matching: find.byType(TextField)),
      findsNothing,
    );

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.byType(AddStudentScreen), findsNothing);
    expect(find.byType(StudentListScreen), findsOneWidget);
    expect(find.text('Student Directory'), findsOneWidget);
  });
}
