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