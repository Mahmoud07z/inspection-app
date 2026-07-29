/// Every REST endpoint path lives here.
/// Pass `--dart-define=API_BASE_URL=https://api.prod.com` at build time to override.
abstract final class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080', // Android emulator → host localhost
  );

  static const String login        = '/api/v1/auth/login';
  static const String users        = '/api/v1/users';
  static const String warehouses   = '/api/v1/warehouses';
  static const String locations    = '/api/v1/locations';
  static const String articles     = '/api/v1/articles';
  static const String inspections  = '/api/v1/inspections';
  static const String damageReports = '/api/v1/damage-reports';

  static String userById(int id)         => '/api/v1/users/$id';
  static String warehouseById(int id)    => '/api/v1/warehouses/$id';
  static String locationById(int id)     => '/api/v1/locations/$id';
  static String articleById(int id)      => '/api/v1/articles/$id';
  static String inspectionById(int id)   => '/api/v1/inspections/$id';
  static String inspectionStatus(int id) => '/api/v1/inspections/$id/status';
  static String damageReportById(int id) => '/api/v1/damage-reports/$id';
}
