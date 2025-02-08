import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather_provider.dart';

class SevenDayForecast extends StatelessWidget {
  const SevenDayForecast({super.key});

  String formatDay(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime);
    const List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[parsedDate.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        if (weatherProvider.isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (weatherProvider.errorMessage.isNotEmpty) {
          return Text(weatherProvider.errorMessage);
        }

        final data = weatherProvider.weatherData!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "5 Day Forecast",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: min(7, data['list'].length ~/ 8),
                itemBuilder: (context, index) {
                  final forecastIndex = index * 8; // Adjust to get daily data
                  if (forecastIndex >= data['list'].length) return Container();
                  final dailyForecast = data['list'][forecastIndex];
                  final dailyIcon = dailyForecast['weather'][0]['main'];
                  final dailyTemp = (dailyForecast['main']['temp'] - 273.15)
                      .toStringAsFixed(1);
                  final dailyDay = formatDay(dailyForecast['dt_txt']);
                  return Card(
                    elevation: 8,
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            dailyDay,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Icon(
                            dailyIcon == "Clouds" || dailyIcon == "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "$dailyTemp °C",
                            style: const TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
