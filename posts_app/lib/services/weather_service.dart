import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather.dart';

class WeatherService {
  final _base = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> fetchWeatherByCity(String city) async {
    final key = dotenv.env['OPENWEATHER_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('Missing OpenWeather API key. Add it to .env');
    }

    final uri = Uri.parse(
      '$_base/weather?q=${Uri.encodeComponent(city)}&appid=$key&units=metric',
    );
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final Map<String, dynamic> map =
          json.decode(res.body) as Map<String, dynamic>;
      return Weather.fromJson(map);
    } else if (res.statusCode == 404) {
      throw Exception('City not found');
    } else {
      throw Exception('Failed to fetch weather: ${res.statusCode}');
    }
  }
}
