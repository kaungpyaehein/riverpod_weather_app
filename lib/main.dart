import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_weather_app/features/current_weather/ui/screen/current_weather_screen.dart';
import 'package:riverpod_weather_app/features/search_city/ui/screens/city_search_screen.dart';
import 'package:riverpod_weather_app/features/theme/provider/theme_state.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});
  final _router = GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, routeState) {
        return const CitySearchScreen();
      },
    ),
    GoRoute(
      path: '/current',
      builder: (context, routeState) {
        final query = routeState.extra as Map;
        return CurrentWeatherScreen(
            city: query['city']!,
            latitude: query['lati']!,
            longitude: query['longi']!);
      },
    )
  ]);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WeatherTheme weatherTheme = ref.watch(themeProvider);
    return MaterialApp.router(
      theme: weatherTheme.getTheme(),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
