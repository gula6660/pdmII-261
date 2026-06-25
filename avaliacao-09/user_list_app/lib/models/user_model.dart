class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? phone;
  final String? website;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.phone,
    this.website,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Nome não disponível',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'website': website,
    };
  }
}