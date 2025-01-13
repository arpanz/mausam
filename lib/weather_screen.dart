import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/additional_item.dart';
import 'package:weather/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'we_key.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "London";
      // Add timeout to the HTTP request
      final res = await http
          .get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openweatherApiKey',
        ),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw 'Connection timeout. Please check your internet connection.';
        },
      );

      if (res.statusCode != 200) {
        throw 'Server returned status code ${res.statusCode}';
      }

      final data = jsonDecode(res.body);

      if (data['cod'] != "200") {
        throw 'API Error: ${data['message'] ?? 'Unknown error occurred'}';
      }

      return data;
    } catch (e) {
      if (e is SocketException) {
        throw 'Network error: Please check your internet connection';
      }
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Weather Pro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;

          final currentData = data['list'][0];

          final currentTemp = currentData['main']['temp'] - 273.15;

          final currentSky = currentData['weather'][0]['main'];

          final currentPressure = currentData['main']['pressure'];

          final windSpeed = currentData['wind']['speed'];

          final humidityData = currentData['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "${currentTemp.toStringAsFixed(2)} °C",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Icon(
                              currentSky == "Clouds" || currentSky == "Rain"
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 60,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              currentSky,
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //weather cards daily/hourly
                const SizedBox(height: 20),
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 1; i <= 5; i++)
                //         //for what is doing
                //         HourlyForecast(
                //           time: data['list'][i + 1]['dt'].toString(),
                //           icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Clouds' ||
                //                   data['list'][i + 1]['weather'][0]['main'] ==
                //                       'Rain'
                //               ? Icons.cloud
                //               : Icons.sunny,
                //           temp: data['list'][i + 1]['main']['temp'].toString(),
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlyIcon = hourlyForecast['weather'][0]['main'];
                      final time = DateTime.parse(hourlyForecast['dt_txt']);
                      return HourlyForecast(
                          time: DateFormat.j().format(time),
                          temp: (hourlyForecast['main']['temp'] - 273.15)
                              .toStringAsFixed(2),
                          icon: hourlyIcon == "Clouds" || hourlyIcon == "Rain"
                              ? Icons.cloud
                              : Icons.sunny);
                    },
                  ),
                ),
                //additional info cards
                const SizedBox(height: 20),
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop_outlined,
                      label: "Humidity",
                      value: humidityData.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: "Wind speed",
                      value: windSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.read_more_outlined,
                      label: "Pressure",
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
