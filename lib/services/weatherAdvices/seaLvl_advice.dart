String getSeaLevelAdvice(int seaLevel) {
  if (seaLevel > 1025) {
    return "High sea-level pressure: Usually clear skies, but dry air may persist.";
  } else if (seaLevel < 1005) {
    return "Low sea-level pressure: May indicate incoming storm systems.";
  } else {
    return "Normal sea-level pressure: Conditions are generally stable.";
  }
}
