class Location {
  const Location({required this.id, required this.code, this.description,
      required this.warehouseId, required this.warehouseCode,
      required this.createdAt, required this.updatedAt});

  final int id;
  final String code;
  final String? description;
  final int warehouseId;
  final String warehouseCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Location.fromJson(Map<String, dynamic> j) => Location(
    id: j['id'] as int, code: j['code'] as String, description: j['description'] as String?,
    warehouseId: j['warehouseId'] as int, warehouseCode: j['warehouseCode'] as String,
    createdAt: DateTime.parse(j['createdAt'] as String),
    updatedAt: DateTime.parse(j['updatedAt'] as String),
  );
}
