import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/additional_item.dart';
import 'package:weather/weather_provider.dart';

class AdditionalInfoScreen extends StatelessWidget {
  String formatTime(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime);
    final hours = parsedDate.hour % 12 == 0 ? 12 : parsedDate.hour % 12;
    final minutes = parsedDate.minute.toString().padLeft(2, '0');
    final period = parsedDate.hour >= 12 ? 'PM' : 'AM';
    return "$hours:$minutes $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Additional Info',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Consumer<WeatherProvider>(
          builder: (context, weatherProvider, child) {
            if (weatherProvider.isLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (weatherProvider.errorMessage.isNotEmpty) {
              return Text(weatherProvider.errorMessage);
            }

            final data = weatherProvider.weatherData!;
            final currentData = data['list'][0];
            final humidityData = currentData['main']['humidity'].toString();
            final windSpeed = currentData['wind']['speed'].toString();
            final currentPressure = currentData['main']['pressure'].toString();
            final sunrise = formatTime(DateTime.fromMillisecondsSinceEpoch(
                    data['city']['sunrise'] * 1000)
                .toLocal()
                .toString());
            final sunset = formatTime(DateTime.fromMillisecondsSinceEpoch(
                    data['city']['sunset'] * 1000)
                .toLocal()
                .toString());
            final uvIndex = data['list'][0]['main']['uvi'].toString();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
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
                      value: "$humidityData%",
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: "Wind speed",
                      value: "$windSpeed m/s",
                    ),
                    AdditionalInfoItem(
                      icon: Icons.read_more_outlined,
                      label: "Pressure",
                      value: "$currentPressure hPa",
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Sunrise & Sunset",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.wb_sunny_outlined,
                      label: "Sunrise",
                      value: sunrise,
                    ),
                    AdditionalInfoItem(
                      icon: Icons.nights_stay_outlined,
                      label: "Sunset",
                      value: sunset,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "UV Index",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: AdditionalInfoItem(
                    icon: Icons.wb_sunny,
                    label: "UV Index",
                    value: uvIndex,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
