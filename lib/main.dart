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
                ? ThemeData(
                    brightness: Brightness.dark,
                    colorScheme: ColorScheme.dark(
                      primary: Color(0xFF6A5ACD), // Sophisticated slate blue
                      secondary: Color(0xFF4B0082), // Deep indigo
                      surface: Color(0xFF1E1E2C), // Deep, rich dark blue-grey
                      surfaceBright:
                          Color(0xFF121212), // Almost black background
                    ),
                    scaffoldBackgroundColor: Color(0xFF1E1E2C),
                    appBarTheme: AppBarTheme(
                      backgroundColor: Color(0xFF121212),
                      foregroundColor: Colors.white70,
                      elevation: 0,
                      surfaceTintColor: Colors.transparent,
                    ),
                    textTheme: TextTheme(
                      bodyLarge: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w300,
                      ),
                      bodyMedium: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    cardTheme: CardTheme(
                      color:
                          Color(0xFF2C2C3E), // Slightly lighter than background
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    iconTheme: IconThemeData(color: Color(0xFF6A5ACD)),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6A5ACD),
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                      ),
                    ),
                    dialogBackgroundColor: Color(0xFF1E1E2C),
                  )
                : ThemeData(
                    brightness: Brightness.light,
                    colorScheme: ColorScheme.light(
                      primary: Color(0xFF3A5A95), // Refined navy blue
                      secondary: Color(0xFF5D7DB3), // Soft blue
                      surface: Color(0xFFF5F7FA), // Very light grey-blue
                      surfaceBright: Colors.white,
                    ),
                    scaffoldBackgroundColor: Color(0xFFF5F7FA),
                    appBarTheme: AppBarTheme(
                      backgroundColor: Color(0xFF3A5A95),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      surfaceTintColor: Colors.transparent,
                    ),
                    textTheme: TextTheme(
                      bodyLarge: TextStyle(
                        color: Color(0xFF2C3E50),
                        fontWeight: FontWeight.w300,
                      ),
                      bodyMedium: TextStyle(
                        color: Color(0xFF2C3E50),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    cardTheme: CardTheme(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    iconTheme: IconThemeData(color: Color(0xFF3A5A95)),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3A5A95),
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                      ),
                    ),
                    dialogBackgroundColor: Colors.white,
                  ),
            home: const WeatherScreen(),
          );
        },
      ),
    );
  }
}
