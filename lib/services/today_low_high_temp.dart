String getHighTemp(List<Map<String, dynamic>> hourlyData) {
  int high = hourlyData.first['temp'];

  for (var data in hourlyData) {
    int temp = data['temp'];
    if (temp > high) {
      high = temp;
    }
  }
  return "$high";
}

String getLowTemp(List<Map<String, dynamic>> hourlyData) {
  int low = hourlyData.first['temp'];

  for (var data in hourlyData) {
    int temp = data['temp'];
    if (temp < low) {
      low = temp;
    }
  }
  return "$low";
}
