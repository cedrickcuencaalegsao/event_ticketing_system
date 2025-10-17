import 'package:event_ticketing_system/models/ticketmode.dart';
import 'package:event_ticketing_system/models/favoritesmodel.dart';
import 'package:event_ticketing_system/models/notificationmodel.dart';

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



