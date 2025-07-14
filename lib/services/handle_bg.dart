import 'package:weather_bloc_app/services/get_greetings.dart';
import 'package:weather_bloc_app/services/random_generator.dart';

String getBgImage() {
  final time = getGreeting();
  if (time == "Good Morning!" || time == "Good Afternoon!") {
    return randomBgDayImage();
  } else {
    return randomBgNightImage();
  }
}
