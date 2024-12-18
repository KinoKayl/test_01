class User {
  final int? id;
  final String username;
  final String password;
  final String fullName;
  final String role; // "user" или "admin"
  final String avatarPath;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.fullName,
    required this.role,
    required this.avatarPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'fullName': fullName,
      'role': role,
      'avatarPath': avatarPath,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      fullName: map['fullName'],
      role: map['role'],
      avatarPath: map['avatarPath'],
    );
  }
}

class Gift {
  final int? id;
  final String name;
  final String description;
  final String imageUrl;
  final String cardText;
  final int userId;

  Gift({
    this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.cardText,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'cardText': cardText,
      'userId': userId,
    };
  }

  factory Gift.fromMap(Map<String, dynamic> map) {
    return Gift(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      cardText: map['cardText'],
      userId: map['userId'],
    );
  }
}
