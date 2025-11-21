class Weather {
  final String cityName;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String iconCode;

  Weather({
    required this.cityName,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.iconCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] as String,
      temp: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: (json['main']['humidity'] as num).toInt(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: (json['weather'] as List).isNotEmpty
          ? json['weather'][0]['description'] as String
          : 'N/A',
      iconCode: (json['weather'] as List).isNotEmpty
          ? json['weather'][0]['icon'] as String
          : '01d',
    );
  }

  String iconUrl() => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
}
