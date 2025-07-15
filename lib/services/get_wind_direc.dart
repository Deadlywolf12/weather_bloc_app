String getWindDirection(int degree) {
  if (degree >= 337.5 || degree < 22.5) return "North";
  if (degree >= 22.5 && degree < 67.5) return "North East";
  if (degree >= 67.5 && degree < 112.5) return "East";
  if (degree >= 112.5 && degree < 157.5) return "South East";
  if (degree >= 157.5 && degree < 202.5) return "South";
  if (degree >= 202.5 && degree < 247.5) return "South West";
  if (degree >= 247.5 && degree < 292.5) return "West";
  if (degree >= 292.5 && degree < 337.5) return "North West";
  return "North";
}
