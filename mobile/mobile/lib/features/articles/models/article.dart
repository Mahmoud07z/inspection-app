class Article {
  const Article({required this.id, required this.code, required this.name,
      this.description, required this.createdAt, required this.updatedAt});

  final int id;
  final String code;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Article.fromJson(Map<String, dynamic> j) => Article(
    id: j['id'] as int, code: j['code'] as String, name: j['name'] as String,
    description: j['description'] as String?,
    createdAt: DateTime.parse(j['createdAt'] as String),
    updatedAt: DateTime.parse(j['updatedAt'] as String),
  );
}
