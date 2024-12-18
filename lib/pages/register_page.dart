import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models.dart';
import '../widgets/avatar_picker.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String role = "user";
  String avatarPath = "";

  void _register() async {
    final username = usernameController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword || username.isEmpty || avatarPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Заполните все поля корректно')),
      );
      return;
    }

    final newUser = User(
      username: username,
      password: password,
      fullName: fullNameController.text,
      role: role,
      avatarPath: avatarPath,
    );

    final db = DatabaseHelper.instance;
    await db.createUser(newUser);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Регистрация')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            AvatarPicker(onAvatarSelected: (path) => avatarPath = path),
            TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Логин')),
            TextField(controller: fullNameController, decoration: InputDecoration(labelText: 'ФИО')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Пароль'), obscureText: true),
            TextField(controller: confirmPasswordController, decoration: InputDecoration(labelText: 'Повторите пароль'), obscureText: true),
            ElevatedButton(onPressed: _register, child: Text('Зарегистрироваться')),
          ],
        ),
      ),
    );
  }
}
