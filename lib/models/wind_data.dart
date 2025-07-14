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
      speed: (json['speed'] as num).toDouble(),
      deg: (json['deg'] as num).toDouble(),
      gust: (json['gust'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'speed': speed,
        'deg': deg,
        if (gust != null) 'gust': gust,
      };
}
