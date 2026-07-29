class Warehouse {
  const Warehouse({required this.id, required this.code, required this.name,
      this.address, required this.createdAt, required this.updatedAt});

  final int id;
  final String code;
  final String name;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Warehouse.fromJson(Map<String, dynamic> j) => Warehouse(
    id: j['id'] as int, code: j['code'] as String, name: j['name'] as String,
    address: j['address'] as String?,
    createdAt: DateTime.parse(j['createdAt'] as String),
    updatedAt: DateTime.parse(j['updatedAt'] as String),
  );
}
