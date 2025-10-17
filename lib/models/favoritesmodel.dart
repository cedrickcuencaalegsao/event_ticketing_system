class Favorite {
  final int id;
  final int eventId;

  Favorite({required this.id, required this.eventId});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      eventId: json['eventId'],
    );
  }
}