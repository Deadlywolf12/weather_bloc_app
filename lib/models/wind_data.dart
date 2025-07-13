class Wind {
  final double speed;
  final double deg;
  final double? gust;

  Wind({
    required this.speed,
    required this.deg,
    this.gust,
  });

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: (json['speed'] ?? 0).toDouble(),
      deg: json['deg'],
      gust: json['gust'] != null ? (json['gust']).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'speed': speed,
        'deg': deg,
        if (gust != null) 'gust': gust,
      };
}
