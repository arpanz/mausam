import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
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
      String cityName = "Varanasi";
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,ind&APPID=$openweatherApiKey'),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != "200") {
        throw 'an error occured :)';
      }

      return (data);
    } catch (e) {
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
              print("refresh");
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

          final CurrentTemp = currentData['main']['temp'];

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
                              "$CurrentTemp K",
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 1; i <= 5; i++)
                        HourlyForecast(
                          time: "00:00",
                          temp: "80F",
                          icon: Icons.cloud,
                        ),
                    ],
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
