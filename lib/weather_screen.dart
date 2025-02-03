import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'sunrise_sunset_widget.dart';
import 'weather_model.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _searchController = TextEditingController();
  WeatherLocation? weather;
  List<WeatherLocation> weatherData = [];

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    final String response =
    await rootBundle.loadString('assets/weather_data.json');
    final data = json.decode(response);

    setState(() {
      weatherData = (data['weatherData'] as List)
          .map((item) => WeatherLocation.fromJson(item))
          .toList();

      if (weatherData.isNotEmpty) {
        weather = weatherData[0];
      }
    });
  }

  void _searchWeather() {
    String searchQuery = _searchController.text.trim();
    setState(() {
      weather = weatherData.firstWhere(
            (location) =>
        location.location.toLowerCase() == searchQuery.toLowerCase(),
        orElse: () => weather!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hintText: "Search Location",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (value) {
                    _searchWeather();
                  },
                ),
                const SizedBox(height: 20),
                weather == null || weather!.weather_emoji.isEmpty
                    ? Container()
                    : Text(
                  weather!.weather_emoji,
                  style: TextStyle(fontSize: 100),
                ),
                weather == null || weather!.location.isEmpty
                    ? Text("No data found",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red))
                    : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weather!.location,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Image.asset("assets/Vector.png",
                            width: 21, height: 21),
                      ],
                    ),
                    Text(
                      "${weather!.temperature}",
                      style: TextStyle(
                          fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    if (weather!.warnings != null)
                      Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.warning,
                                        color: Colors.yellow),
                                    SizedBox(width: 10),
                                    Text(
                                      "WARNING",
                                      style: TextStyle(
                                          color: Colors.yellow,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(
                                  weather!.warnings!.weather_emoji,
                                  style: TextStyle(
                                      fontSize: 40
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "% RAIN",
                                      style:
                                      TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      weather!.warnings!.rain_percentage,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "EXP. TIME",
                                      style:
                                      TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      weather!.warnings!.expected_time,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              weather!.warnings!.warning_title,
                              style: TextStyle(
                                color: Colors.yellow,
                              ),
                            ),
                          ],
                        ),
                      ),
                    _buildWeatherDetails(weather!),
                    const SizedBox(height: 20),
                    SunriseSunsetWidget(
                      sunrise: weather!.sunrise,
                      sunset: weather!.sunset,
                      dayLength: weather!.day_length,
                      remainingDaylight:
                      _calculateRemainingDaylight(weather!),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetails(WeatherLocation weather) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem("TIME", "11:25 AM"),
              _buildDetailItem("UV", weather.uv_index.toString()),
              _buildDetailItem("% RAIN", weather.rain_percentage),
              _buildDetailItem("AQ", weather.air_quality),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.grey)),
        Text(value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _calculateRemainingDaylight(WeatherLocation weather) {
    try {
      List<String> dayLengthParts = weather.day_length.split(" ");
      int totalHours = int.parse(dayLengthParts[0].replaceAll('h', '').trim());
      int totalMinutes =
      int.parse(dayLengthParts[1].replaceAll('m', '').trim());

      DateFormat timeFormat = DateFormat("hh:mm a");
      DateTime currentTime = timeFormat.parse("11:25 AM");
      DateTime sunriseTime = timeFormat.parse(weather.sunrise);

      Duration elapsedTime = currentTime.difference(sunriseTime);

      int elapsedHours = elapsedTime.inHours;
      int elapsedMinutes = elapsedTime.inMinutes % 60;

      int remainingHours = totalHours - elapsedHours;
      int remainingMinutes = totalMinutes - elapsedMinutes;

      if (remainingMinutes < 0) {
        remainingMinutes += 60;
        remainingHours -= 1;
      }

      remainingHours = remainingHours < 0 ? 0 : remainingHours;
      remainingMinutes = remainingMinutes < 0 ? 0 : remainingMinutes;

      return "${remainingHours}H ${remainingMinutes}M";
    } catch (e) {
      print("Error calculating remaining daylight: $e");
      return "0H 0M";
    }
  }
}
