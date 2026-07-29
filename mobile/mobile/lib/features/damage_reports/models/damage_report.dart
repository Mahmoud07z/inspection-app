class DamageReport {
  const DamageReport({
    required this.id, required this.inspectionId, required this.inspectionCode,
    required this.articleId, required this.articleCode, required this.articleName,
    required this.locationId, required this.locationCode, required this.severity,
    required this.description, this.photoUrl, required this.createdAt, required this.updatedAt,
  });

  final int id;
  final int inspectionId;
  final String inspectionCode;
  final int articleId;
  final String articleCode;
  final String articleName;
  final int locationId;
  final String locationCode;
  final String severity;
  final String description;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory DamageReport.fromJson(Map<String, dynamic> j) => DamageReport(
    id: j['id'] as int,
    inspectionId: j['inspectionId'] as int,
    inspectionCode: j['inspectionCode'] as String,
    articleId: j['articleId'] as int,
    articleCode: j['articleCode'] as String,
    articleName: j['articleName'] as String,
    locationId: j['locationId'] as int,
    locationCode: j['locationCode'] as String,
    severity: j['severity'] as String,
    description: j['description'] as String,
    photoUrl: j['photoUrl'] as String?,
    createdAt: DateTime.parse(j['createdAt'] as String),
    updatedAt: DateTime.parse(j['updatedAt'] as String),
  );
}
