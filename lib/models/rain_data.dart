class Rain {
  final double? threeHour;

  Rain({this.threeHour});

  factory Rain.fromJson(Map<String, dynamic> json) {
    return Rain(
      threeHour: json['3h'] != null ? (json['3h']).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (threeHour != null) '3h': threeHour,
      };
}
