import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String selectedRole = 'user'; // Default role

  void register() async {
    final username = usernameController.text.trim();
    final fullName = fullNameController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (username.isEmpty || fullName.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Все поля обязательны для заполнения')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пароли не совпадают')),
      );
      return;
    }

    final db = DatabaseHelper.instance;
    final existingUser = await db.getUser(username, password);
    if (existingUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пользователь с таким логином уже существует')),
      );
      return;
    }

    final newUser = User(
      username: username,
      password: password,
      fullName: fullName,
      role: selectedRole,
      avatarPath: '', // Default empty avatar path
    );

    await db.createUser(newUser);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Регистрация успешна')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Логин'),
            ),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'ФИО'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Повторите пароль'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRole,
              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Роль'),
              items: [
                DropdownMenuItem(value: 'user', child: Text('Пользователь')),
                DropdownMenuItem(value: 'admin', child: Text('Администратор')),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: register,
              child: Text('Зарегистрироваться'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Назад к авторизации'),
            ),
          ],
        ),
      ),
    );
  }
}
