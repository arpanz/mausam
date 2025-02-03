import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'we_key.dart';

class WeatherProvider extends ChangeNotifier {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String _errorMessage = '';

  Map<String, dynamic>? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchWeather() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      String cityName = "Bhubaneswar";
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,ind&APPID=$openweatherApiKey'),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != "200") {
        throw 'An error occurred :)';
      }

      // Fetch UV index data
      final uvRes = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/uvi?lat=${data['city']['coord']['lat']}&lon=${data['city']['coord']['lon']}&appid=$openweatherApiKey'),
      );
      final uvData = jsonDecode(uvRes.body);
      data['list'][0]['main']['uvi'] = uvData['value'];

      _weatherData = data;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
