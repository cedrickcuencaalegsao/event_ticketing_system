import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;
  final String location;
  final List<Ticket> tickets;
  final List<Favorite> favorites;
  final List<Notification> notifications;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.tickets,
    required this.favorites,
    required this.notifications,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      location: json['location'],
      tickets: (json['tickets'] as List)
          .map((ticketJson) => Ticket.fromJson(ticketJson))
          .toList(),
      favorites: (json['favorites'] as List)
          .map((favJson) => Favorite.fromJson(favJson))
          .toList(),
      notifications: (json['notifications'] as List)
          .map((notifJson) => Notification.fromJson(notifJson))
          .toList(),
    );
  }
}

class Ticket {
  final int id;
  final int eventId;
  final String ticketNumber;
  final String seats;
  final String status;

  Ticket({
    required this.id,
    required this.eventId,
    required this.ticketNumber,
    required this.seats,
    required this.status,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      eventId: json['eventId'],
      ticketNumber: json['ticketNumber'],
      seats: json['seats'],
      status: json['status'],
    );
  }
}

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

class Notification {
  final int id;
  final String title;
  final String message;
  final bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      isRead: json['isRead'],
    );
  }
}