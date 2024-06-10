import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:isdfinal/app_helper.dart';
import 'package:provider/provider.dart';

class User{
  final int id;
  final String firstname;
  final String email;
  final String lastname;
  final String profile;
  User({required this.id, required this.firstname, required this.email, required this.lastname, required this.profile});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      profile: json['profileImage']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
    };
  }
}

class UserService {

  Future<List<User>> getAllUsers() async {
    final response = await http.get(Uri.parse('${AppHelper.baseUrl}/users/getAll'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('${AppHelper.baseUrl}/users/getById/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  Future<User> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('${AppHelper.baseUrl}/users/update/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('${AppHelper.baseUrl}/users/delete/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}