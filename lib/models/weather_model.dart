class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final int sunrise;
  final int sunset;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',

      temperature: (json['main']['temp'] ?? 0).toDouble(),

      description: (json['weather'] as List).first['description'].toString(),

      humidity: json['main']['humidity'] ?? 0,

      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),

      sunrise: json['sys']['sunrise'] ?? 0,

      sunset: json['sys']['sunset'] ?? 0,
    );
  }
}
