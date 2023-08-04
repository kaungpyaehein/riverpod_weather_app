import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_weather_app/features/theme/provider/theme_provider.dart';

sealed class WeatherTheme {
  ThemeData getTheme();
}

class LightTheme extends WeatherTheme {
  @override
  ThemeData getTheme() {
    return ThemeData.light().copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.indigo,
      )
    );
  }
}

class DarkTheme extends WeatherTheme {
  @override
  ThemeData getTheme() {
    return ThemeData.dark();
  }
}

NotifierProvider<ThemeNotifier, WeatherTheme> themeProvider =
    NotifierProvider(() {
  return ThemeNotifier();
});
