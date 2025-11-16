import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'screens/splash_screen.dart';
import 'screens/home_page.dart';

void main() {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Bogota')); // Ajusta a tu zona horaria
  initializeDateFormatting('es_ES', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteca Personal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade900,
          brightness: Brightness.dark,
        ).copyWith(
          primary: Colors.blue.shade900,
          secondary: Colors.blue.shade800,
          tertiary: Colors.blue.shade700,
          surface: Colors.grey.shade900,
          onSurface: Colors.white,
          surfaceContainerHighest: Colors.blue.shade800,
        ),
        useMaterial3: true,
        fontFamily: 'Nunito',
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade800,
          labelStyle: TextStyle(color: Colors.blue.shade600),
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: const Color(0xFF2A2A2A),
          shadowColor: Colors.blue.shade900.withOpacity(0.5),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.blue.shade800,
          labelStyle: const TextStyle(color: Colors.white),
          selectedColor: Colors.blue.shade700,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.blue.shade900,
          contentTextStyle: const TextStyle(color: Colors.white),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}


