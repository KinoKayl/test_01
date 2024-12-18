import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models.dart';
import 'user_home_page.dart';
import 'admin_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Введите логин и пароль')),
      );
      return;
    }

    final db = DatabaseHelper.instance;
    final user = await db.getUser(username, password);

    if (user != null) {
      if (user.role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage(user: user)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHomePage(user: user)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Неверный логин или пароль')),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Авторизация', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Логин')),
              SizedBox(height: 12),
              TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Пароль')),
              SizedBox(height: 24),
              ElevatedButton(onPressed: _login, child: Text('Войти')),
              SizedBox(height: 12),
              TextButton(onPressed: _navigateToRegister, child: Text('Зарегистрироваться')),
            ],
          ),
        ),
      ),
    );
  }
}
