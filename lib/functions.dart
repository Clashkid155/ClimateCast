import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'generated/assets.dart';

/*getWeather() async {
  final wf = WeatherFactory("16212941d576264834bb758b9ff270a5");
  final wed = await wf.currentWeatherByCityName("Awka");
  // print(wed);
  // print(wed.temperature?.celsius);
}*/

String formatDate(DateTime? val) {
  if (val == null) return "";
  final date = DateFormat("EEEE - d MMMM");
  return date.format(val);
}

String firstToUpper(String? val) {
  if (val == null) return "";
  return val.replaceFirst(val[0], val[0].toUpperCase());
}

IconData weatherIcon(int? code) {
  // if (code ==null) return

  return switch (code) {
    (200 || 201 || 202 || 210 || 211 || 212 || 221 || 230 || 231 || 232) =>
      Icons.sunny,
    (300 || 301 || 302 || 310 || 311 || 312 || 313 || 314 || 321) =>
      Icons.cloud,
    (500 || 501 || 502 || 503 || 504 || 511 || 520 || 521 || 522 || 531) =>
      Icons.cloud,
    (701 || 711 || 721 || 731 || 741 || 751 || 761 || 762 || 771 || 781) =>
      Icons.cloud,
    801 || 802 || 803 || 804 => Icons.sunny,
    _ => Icons.sunny,
  };
}

/// App background should be based on weather and time of the day
String appBackground(int? code, String timeOfDay) {
  final time = TimeOfDay.now().hour;
  return switch (code) {
    /// Thunderstorm (raining)
    (200 || 201 || 202 || 210 || 211 || 212 || 221 || 230 || 231 || 232) =>
      Assets.imagesRaining,
/*    (200 || 201 || 202 || 210 || 211 || 212 || 221 || 230 || 231 || 232)
        when timeOfDay.contains("evening") || timeOfDay.contains("night") =>
      Assets.imagesRaining,*/
    /// Drizzle
    (300 || 301 || 302 || 310 || 311 || 312 || 313 || 314 || 321) =>
      Assets.imagesRaining,

    /// Raining
    (500 || 501 || 502 || 503 || 504 || 511 || 520 || 521 || 522 || 531) =>
      Assets.imagesRaining,
    (701 || 711 || 721 || 731 || 741 || 751 || 761 || 762 || 771 || 781) =>
      Assets.imagesDarkCloud,

    /// Clouds (morning & afternoon)
    (801 || 802 || 803 || 804) when time >= 7 => Assets.imagesBrightCloud,

    /// Clouds (evening)
    (801 || 802 || 803 || 804) when time <= 7 || time <= 20 =>
      Assets.imagesDarkNightSkyResized,
    _ => Assets.imagesBrightCloud,
  };
}

String constructLocalIconUrl(String? code) {
  return "assets/weather_icons/${code ?? "01d"}@2x.png";
}

String dayTime() {
  final time = TimeOfDay.now().hour;
  // print(time);
  if (time < 12) {
    return "Good morning";
  } else if (time <= 16) {
    return "Good afternoon";
  } else if (time <= 20) {
    return "Good evening";
  } else {
    return "Goodnight";
  }
}
