import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:event_ticketing_system/models/usermodel.dart';
import 'package:event_ticketing_system/models/eventmodel.dart';
import 'package:event_ticketing_system/models/categorymodel.dart';

class ApiService {
  final String _baseUrl = "https://my-json-server.typicode.com/cedrickcuencaalegsao/my_db";

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse('$_baseUrl/events'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Event> events = body.map((dynamic item) => Event.fromJson(item)).toList();
      return events;
    } else {
      throw Exception('Failed to load events');
    }
  }
  Future<User> fetchUser(int userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Category> categories = body.map((dynamic item) => Category.fromJson(item)).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}