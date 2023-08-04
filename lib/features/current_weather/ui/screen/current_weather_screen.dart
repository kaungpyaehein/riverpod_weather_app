import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_weather_app/features/current_weather/provider/current_weather_state/current_weather_provider.dart';
import 'package:riverpod_weather_app/features/current_weather/provider/current_weather_state/current_weather_state.dart';

import '../../data/model/current_weather_model.dart';

class CurrentWeatherScreen extends ConsumerStatefulWidget {
  final String latitude;
  final String longitude;
  final String city;
  const CurrentWeatherScreen(
      {required this.latitude,
      required this.longitude,
      required this.city,
      super.key});

  @override
  ConsumerState<CurrentWeatherScreen> createState() =>
      _CurrentWeatherScreenState();
}

class _CurrentWeatherScreenState extends ConsumerState<CurrentWeatherScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _getWeather();
  }

  @override
  Widget build(BuildContext context) {
    final currentWeatherState = ref.watch(currentWeatherProvider);
    return Scaffold(
      body: Stack(
        children: [
          _weatherWidget(currentWeatherState),
          SafeArea(
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, icon: const Icon(Icons.arrow_back))),
        ],
      ),
    );
  }

  void _getWeather() async {
    await Future.delayed(Duration.zero);
    ref
        .read(currentWeatherProvider.notifier)
        .getWeather(latitude: widget.latitude, longitude: widget.longitude);
  }

  Widget _weatherWidget(CurrentWeatherState currentWeatherState) {
    return switch (currentWeatherState) {
      CurrentWeatherLoadingState() => const Center(
          child: CircularProgressIndicator(),
        ),
      CurrentWeatherSuccessState(
        currentWeatherModel: CurrentWeatherModel current
      ) =>
        CurrentWeatherWidget(widget: widget, current: current),
      CurrentWeatherFailedState(errorMessage: String error) => Center(
          child: Text("Something went wrong! $error"),
        )
    };
  }
}

class CurrentWeatherWidget extends StatelessWidget {
  const CurrentWeatherWidget({
    super.key,
    required this.widget,
    required this.current,
  });

  final CurrentWeatherScreen widget;
  final CurrentWeatherModel current;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0xff5C6BC0),
            Color(0xff3949AB),
            Color(0xff283593)
          ])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.city,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "${current.currentWeather?.weathercode?.toCondition().toEmoji()}",
                    style: const TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "${current.currentWeather?.weathercode?.toCondition()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "${current.currentWeather?.temperature ?? ""}°C",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

extension on num {
  String toCondition() {
    switch (this) {
      case 0:
        return "Clear";
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return "Cloudy";
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return "Rainy";
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return "Snowy";
      default:
        return "Unknown";
    }
  }
}

extension on String {
  String toEmoji() {
    switch (this) {
      case "Clear":
        return '☀️';
      case "Rainy":
        return '🌧️';
      case "Cloudy":
        return '☁️';
      case "Snowy":
        return '🌨️';
      case "Unknown":
        return '❓';
      default:
        return "Unknown";
    }
  }
}
