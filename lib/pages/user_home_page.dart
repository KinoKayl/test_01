import 'dart:math';
import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../models.dart';

class UserHomePage extends StatefulWidget {
  final User user;

  UserHomePage({required this.user});

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  List<Gift> gifts = [];

  @override
  void initState() {
    super.initState();
    _fetchGifts();
  }

  void _fetchGifts() async {
    final db = DatabaseHelper.instance;
    final giftList = await db.getAllGifts();
    setState(() {
      gifts = giftList;
    });
  }

  void _assignRandomGiftToUser() async {
    if (gifts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Нет доступных подарков')),
      );
      return;
    }

    final random = Random();
    final randomGift = gifts.where((gift) => gift.userId == null).toList();
    if (randomGift.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Все подарки уже распределены')),
      );
      return;
    }

    final selectedGift = randomGift[random.nextInt(randomGift.length)];
    final db = DatabaseHelper.instance;
    await db.updateGiftUser(selectedGift.id!, widget.user.id!);

    _fetchGifts();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Подарок "${selectedGift.name}" присвоен')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Домашняя страница'),
        actions: [
          Row(
            children: [
              if (widget.user.avatarPath != null && widget.user.avatarPath.isNotEmpty)
                CircleAvatar(
                  backgroundImage: AssetImage(widget.user.avatarPath),
                ),
              SizedBox(width: 8),
              Text(widget.user.username),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: _assignRandomGiftToUser,
              child: Text('Получить случайный подарок'),
            ),
          ),
          Expanded(
            child: gifts.isEmpty
                ? Center(child: Text('Нет доступных подарков'))
                : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: gifts.length,
              itemBuilder: (context, index) {
                final gift = gifts[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: gift.imageUrl != null && gift.imageUrl.isNotEmpty
                            ? Image.asset(gift.imageUrl, fit: BoxFit.cover)
                            : Icon(Icons.card_giftcard, size: 50),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          gift.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
