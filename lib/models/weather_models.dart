class Weather {
  final String cityName;
  final double temprature;
  final String description;
  final int humidity;
  final double windspeed;
  final int sunrise;
  final int sunset;

  Weather({
    required this.cityName,
    required this.description,
    required this.humidity,
    required this.sunrise,
    required this.sunset,
    required this.temprature,
    required this.windspeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      description:
          (json['weather'] as List<dynamic>?)?.first['description'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      sunrise: json['sys']['sunrise'] ?? 0,
      sunset: json['sys']['sunset'] ?? 0,
      temprature: (json['main']['temp'] ?? 0) - 273.15,
      windspeed: (json['wind']['speed'] ?? 0).toDouble(),
    );
  }
}
