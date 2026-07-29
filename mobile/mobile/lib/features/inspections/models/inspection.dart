class Inspection {
  const Inspection({
    required this.id, required this.inspectionCode, required this.warehouseId,
    required this.warehouseCode, required this.inspectorId, required this.inspectorName,
    required this.status, required this.scheduledDate, this.notes,
    required this.damageReportCount, required this.createdAt, required this.updatedAt,
  });

  final int id;
  final String inspectionCode;
  final int warehouseId;
  final String warehouseCode;
  final int inspectorId;
  final String inspectorName;
  final String status;
  final DateTime scheduledDate;
  final String? notes;
  final int damageReportCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Inspection.fromJson(Map<String, dynamic> j) => Inspection(
    id: j['id'] as int,
    inspectionCode: j['inspectionCode'] as String,
    warehouseId: j['warehouseId'] as int,
    warehouseCode: j['warehouseCode'] as String,
    inspectorId: j['inspectorId'] as int,
    inspectorName: j['inspectorName'] as String,
    status: j['status'] as String,
    scheduledDate: DateTime.parse(j['scheduledDate'] as String),
    notes: j['notes'] as String?,
    damageReportCount: j['damageReportCount'] as int? ?? 0,
    createdAt: DateTime.parse(j['createdAt'] as String),
    updatedAt: DateTime.parse(j['updatedAt'] as String),
  );
}
