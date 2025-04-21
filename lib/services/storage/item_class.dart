class ClosetImage {
  String url;
  String name;
  String color;
  String type;
  String weatherType;
  String? docId;

  ClosetImage({
    required this.url,
    required this.name,
    required this.color,
    required this.type,
    required this.weatherType,
    this.docId,
  });

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'name': name,
      'color': color,
      'type': type,
      'weatherType': weatherType,
    };
  }

  factory ClosetImage.fromMap(Map<String, dynamic> map) {
    return ClosetImage(
      url: map['url'],
      name: map['name'],
      color: map['color'],
      type: map['type'],
      weatherType: map['weatherType'],
    );
  }
}