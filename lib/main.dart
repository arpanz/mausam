import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather_screen.dart';
import 'package:weather/weather_provider.dart';
import 'package:weather/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.isDarkMode
                ? ThemeData.dark(useMaterial3: true)
                : ThemeData(
                    brightness: Brightness.light,
                    primaryColor: Colors.blueAccent,
                    scaffoldBackgroundColor: Colors.white,
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    textTheme: const TextTheme(
                      bodyLarge: TextStyle(color: Colors.black87),
                      bodyMedium: TextStyle(color: Colors.black87),
                    ),
                    cardColor: Colors.blue[50],
                    iconTheme: const IconThemeData(color: Colors.blueAccent),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                        onPrimary: Colors.white,
                      ),
                    ),
                  ),
            home: const WeatherScreen(),
          );
        },
      ),
    );
  }
}
