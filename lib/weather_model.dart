class WeatherLocation {
  final String location;
  final String weather_emoji;
  final String temperature;
  final int uv_index;
  final String rain_percentage;
  final String air_quality;
  final String sunrise;
  final String sunset;
  final String day_length;
  final Warning? warnings;

  WeatherLocation({
    required this.location,
    required this.weather_emoji,
    required this.temperature,
    required this.uv_index,
    required this.rain_percentage,
    required this.air_quality,
    required this.sunrise,
    required this.sunset,
    required this.day_length,
    this.warnings,
  });

  factory WeatherLocation.fromJson(Map<String, dynamic> json) {
    return WeatherLocation(
      location: json['location'],
      weather_emoji: json['weather_emoji'],
      temperature: json['temperature'],
      uv_index: json['uv_index'],
      rain_percentage: json['rain_percentage'],
      air_quality: json['air_quality'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      day_length: json['day_length'],
      warnings: json['warnings'] != null
          ? Warning.fromJson(json['warnings'])
          : null,
    );
  }
}

class Warning {
  final String weather_emoji;
  final String rain_percentage;
  final String expected_time;
  final String warning_title;

  Warning({
    required this.weather_emoji,
    required this.rain_percentage,
    required this.expected_time,
    required this.warning_title,
  });

  factory Warning.fromJson(Map<String, dynamic> json) {
    return Warning(
      weather_emoji: json['weather_emoji'],
      rain_percentage: json['rain_percentage'],
      expected_time: json['expected_time'],
      warning_title: json['warning_title'],
    );
  }
}
