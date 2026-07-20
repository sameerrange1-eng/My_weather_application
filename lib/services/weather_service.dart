import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = "7e613bc6620a004cd01589a63c42dadb";
  static const String _baseUrl =
      "https://api.openweathermap.org/data/2.5/weather";

  Future<Weather> getCurrentWeather() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied.");
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied.");
    }

    Position position = await Geolocator.getCurrentPosition();

    final url = Uri.parse(
      "$_baseUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Unable to fetch weather.");
    }

    return Weather.fromJson(jsonDecode(response.body));
  }
}
