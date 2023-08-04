// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_weather_app/features/search_city/providers/state/city_search_state.dart';
import 'package:riverpod_weather_app/features/search_city/ui/widgets/city_list_widget.dart';
import 'package:riverpod_weather_app/features/theme/provider/theme_state.dart';

import '../../data/model/city_search_result.dart';
import '../../providers/city_search_provider.dart';

class CitySearchScreen extends ConsumerStatefulWidget {
  const CitySearchScreen({super.key});

  @override
  ConsumerState<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends ConsumerState<CitySearchScreen> {
  final TextEditingController _citySearchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final citySearchState = ref.watch(citySearchProvider);
    final provider = ref.read(citySearchProvider.notifier);
    final weatherTheme = ref.watch(themeProvider);
    final weatherProvider = ref.read(themeProvider.notifier);
    return  Scaffold(
      appBar: AppBar(
        title: Text("Riverpod Weather"),
        centerTitle: true,
        actions: [
          Switch(value: (weatherTheme is DarkTheme), onChanged: (val){
            if(val){
              weatherProvider.changeTheme(DarkTheme());
            }
            else{
              weatherProvider.changeTheme(LightTheme());
            }
          })
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _citySearchTextController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Search City",
                suffixIcon: IconButton(onPressed: (){
                  String city = _citySearchTextController.text.trim();
                  if(city.isEmpty){
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Please enter a city name")));
                  }
                  else{
                    provider.searchCity(city);
                  }
                },icon: Icon(Icons.search),)
              ),

            ),
          ),
          Expanded(child: _citySearchResultWidget(citySearchState)),


        ],
      ),
    );
  }
  Widget _citySearchResultWidget(CitySearchState citySearchState){
    return Center(
      child: switch(citySearchState){
        CitySearchForm() => Text("Please Search a city"),
        CitySearchLoading() => CircularProgressIndicator(),
        CitySearchSuccess(citySearchResult : CitySearchResult citySearchResult) => CityList(citySearchResult: citySearchResult),
        CitySearchFailed(errorMessage : String error) => Text(error),

      },
    );
  }
}
