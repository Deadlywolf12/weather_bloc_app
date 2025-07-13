String getWeatherCode(int code) {
  if (code >= 200 && code <= 232) {
    return "rainWThunderStorm";
  } else if (code >= 500 && code <= 531) {
    return "rain";
  } else if (code >= 600 && code <= 622) {
    return "snow";
  } else if (code >= 801 && code <= 804) {
    return "clouds";
  } else {
    return "clear";
  }
}
