import 'dart:convert';

class Post {

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  final int id;
  final int userId;
  final String title;
  final String body;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      userId: map['userId'],
      id: map['id'],
      title: map['title'],
      body: map['body'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  Post copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Post &&
      other.id == id &&
      other.userId == userId &&
      other.title == title &&
      other.body == body;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      title.hashCode ^
      body.hashCode;
  }
}
