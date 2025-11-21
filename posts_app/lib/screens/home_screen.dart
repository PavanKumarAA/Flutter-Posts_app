import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final city = _controller.text.trim();
    if (city.isEmpty) return;
    context.read<WeatherProvider>().search(city);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Weather_Application')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _search(),
                    decoration: const InputDecoration(
                      hintText: 'Enter city name (e.g. London)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _search, child: const Text('Search')),
              ],
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                switch (provider.state) {
                  case WeatherState.loading:
                    return const Center(child: CircularProgressIndicator());
                  case WeatherState.loaded:
                    final w = provider.weather!;
                    return SingleChildScrollView(
                      child: WeatherCard(weather: w),
                    );
                  case WeatherState.error:
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Error: ${provider.error}'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => provider.clear(),
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                  case WeatherState.initial:
                  default:
                    return const Center(
                      child: Text('Search a city to see weather'),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
