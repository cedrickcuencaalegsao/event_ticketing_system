class Event {
  final int id;
  final String title;
  final String date;
  final String location;
  final int price;
  final int categoryId;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.price,
    required this.categoryId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      location: json['location'],
      price: json['price'],
      categoryId: json['categoryId'],
    );
  }
}