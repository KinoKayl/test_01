import 'package:flutter/material.dart';
import '../models.dart';

class UserHomePage extends StatelessWidget {
  final User user;

  UserHomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Домашняя страница'),
        actions: [
          CircleAvatar(
            radius: 18,
            backgroundImage: user.avatarPath.isNotEmpty
                ? AssetImage(user.avatarPath)
                : null,
            child: user.avatarPath.isEmpty ? Icon(Icons.person) : null,
          ),
          SizedBox(width: 8),
          Center(
            child: Text(user.username),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Text('Добро пожаловать, ${user.fullName}!'),
      ),
    );
  }
}
