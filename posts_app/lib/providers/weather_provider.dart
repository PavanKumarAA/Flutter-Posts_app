import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider with ChangeNotifier {
  final WeatherService service;
  WeatherProvider({required this.service});

  WeatherState _state = WeatherState.initial;
  WeatherState get state => _state;

  Weather? _weather;
  Weather? get weather => _weather;

  String _error = '';
  String get error => _error;

  Future<void> search(String city) async {
    _state = WeatherState.loading;
    _error = '';
    notifyListeners();

    try {
      final w = await service.fetchWeatherByCity(city);
      _weather = w;
      _state = WeatherState.loaded;
    } catch (e) {
      _error = e.toString();
      _state = WeatherState.error;
    }
    notifyListeners();
  }

  void clear() {
    _weather = null;
    _error = '';
    _state = WeatherState.initial;
    notifyListeners();
  }
}
