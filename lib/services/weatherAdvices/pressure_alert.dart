String getPressureAdvice(int pressure) {
  if (pressure > 1020) {
    return "High pressure: Expect clear skies, but it may cause headaches.";
  } else if (pressure < 1000) {
    return "Low Pressure: Stormy weather is more likely. Stay cautious!";
  } else {
    return "Normal Pressure: Weather is likely stable.";
  }
}
