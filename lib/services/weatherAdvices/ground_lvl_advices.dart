String getGroundLevelAdvice(int grndLevel) {
  if (grndLevel > 1015) {
    return "High ground pressure: Dry and cool weather likely.";
  } else if (grndLevel < 985) {
    return "Low ground pressure: Could mean increased humidity or storm activity.";
  } else {
    return "Normal ground pressure: Comfortable weather conditions.";
  }
}
