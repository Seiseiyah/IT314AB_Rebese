import 'package:exam_2/screens/friend_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF2B2628),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Color(0xFFEDE8E9)),
          titleMedium: TextStyle(color: Color(0xFFEDE8E9)),
          bodyLarge: TextStyle(color: Color(0xFFEDE8E9)),
          bodyMedium: TextStyle(color: Color(0xFFEDE8E9)),
          bodySmall: TextStyle(color: Color(0xFFC9BFC3)),
        ),
      ),
      home: const FriendClassScreen(),
    );
  }
}
