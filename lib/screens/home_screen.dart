import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();

  Weather? _weather;
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final weather = await _weatherService.getCurrentWeather();

      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String formatTime(int timestamp) {
    return DateFormat(
      'hh:mm a',
    ).format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  }

  Widget infoTile(IconData icon, String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadWeather),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadWeather,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 20),

                  const Icon(Icons.wb_sunny, size: 90, color: Colors.orange),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      _weather!.cityName,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      "${_weather!.temperature.toStringAsFixed(1)}°C",
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      _weather!.description.toUpperCase(),
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ),

                  const SizedBox(height: 30),

                  infoTile(
                    Icons.water_drop,
                    "Humidity",
                    "${_weather!.humidity} %",
                  ),

                  infoTile(
                    Icons.air,
                    "Wind Speed",
                    "${_weather!.windSpeed} m/s",
                  ),

                  infoTile(
                    Icons.wb_sunny_outlined,
                    "Sunrise",
                    formatTime(_weather!.sunrise),
                  ),

                  infoTile(
                    Icons.nights_stay,
                    "Sunset",
                    formatTime(_weather!.sunset),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: _loadWeather,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh Weather"),
                  ),
                ],
              ),
            ),
    );
  }
}
