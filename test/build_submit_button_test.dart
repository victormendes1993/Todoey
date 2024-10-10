import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todoey/models/task_data.dart';
import 'package:todoey/screens/tasks_screen.dart';
import 'package:todoey/screens/widgets/task_sheet.dart';

void main() {
  testWidgets('Submit button adds a task and displays it',
      (WidgetTester tester) async {
    // Create a mock TaskData provider
    final mockTaskData = TaskData();

    // Build the TaskSheet widget wrapped in TasksScreen to display tasks
    await tester.pumpWidget(
      ChangeNotifierProvider<TaskData>.value(
        value: mockTaskData,
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              // Use ScrollView to allow for unbounded height
              child: Column(
                children: [
                  TasksScreen(), // This should display the list of tasks
                  TaskSheet(
                    index: 1,
                  ), // The sheet to add a task
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Find the text field and enter a task description
    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, 'New Task');

    // Find the submit button and tap it
    final submitButtonFinder = find.text('Go');
    await tester.tap(submitButtonFinder);

    // Allow time for the widget to rebuild
    await tester.pumpAndSettle();

    // Check that the task was added to the provider
    expect(mockTaskData.tasks.length, 1); // Ensure there's one task
    expect(
        mockTaskData.tasks.first.title, 'New Task'); // Ensure the title matches

    // Check that the task appears on the screen
    expect(find.text('New Task'),
        findsOneWidget); // Expect to find the task on the screen

    // Check that the ListTile has the correct title
    final listTileFinder = find.byWidgetPredicate(
      (widget) =>
          widget is ListTile && (widget.title as Text).data == 'New Task',
    );
    expect(listTileFinder,
        findsOneWidget); // Expect that a ListTile with the title 'New Task' exists
  });
}
