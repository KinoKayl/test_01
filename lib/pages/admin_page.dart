import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models.dart';

class AdminPage extends StatefulWidget {
  final User user;

  AdminPage({required this.user});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    final db = DatabaseHelper.instance;
    final userList = await db.getAllUsers();
    setState(() {
      users = userList;
    });
  }

  void _deleteUser(int userId) async {
    final db = DatabaseHelper.instance;
    await db.deleteUser(userId);
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Панель администратора'),
        actions: [
          CircleAvatar(
            radius: 18,
            backgroundImage: widget.user.avatarPath.isNotEmpty
                ? AssetImage(widget.user.avatarPath)
                : null,
            child: widget.user.avatarPath.isEmpty ? Icon(Icons.person) : null,
          ),
          SizedBox(width: 8),
          Center(child: Text(widget.user.username)),
          SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: user.avatarPath.isNotEmpty
                  ? AssetImage(user.avatarPath)
                  : null,
              child: user.avatarPath.isEmpty ? Icon(Icons.person) : null,
            ),
            title: Text(user.fullName),
            subtitle: Text(user.username),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteUser(user.id!),
            ),
          );
        },
      ),
    );
  }
}
