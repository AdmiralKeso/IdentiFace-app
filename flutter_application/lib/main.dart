import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/selection_screen.dart';

void main() {
  runApp(const IdentiFaceApp());
}

class IdentiFaceApp extends StatelessWidget {
  const IdentiFaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IdentiFace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/select': (context) => const SelectionScreen(),
      },
    );
  }
}
