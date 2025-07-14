import 'dart:math';

String randomBgDayImage() {
  final List<String> dayImages = [
    "assets/day_rain_bg.jpg",
    "assets/day_bg.jpg",
    "assets/day_bg2.jpg",
  ];

  final Random random = Random();
  final int index = random.nextInt(dayImages.length);
  return dayImages[index];
}

String randomBgNightImage() {
  final List<String> nightImages = [
    "assets/night_rain_bg.jpg",
    "assets/night_bg.jpg",
    "assets/night_bg2.jpg",
    "assets/night_bg3.jpg",
  ];

  final Random random = Random();
  final int index = random.nextInt(nightImages.length);
  return nightImages[index];
}
