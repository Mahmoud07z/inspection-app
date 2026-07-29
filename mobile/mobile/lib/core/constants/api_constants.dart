<<<<<<< HEAD
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
=======
/// Central home for every URL constant used by feature services.
/// Changing the base URL or a path here automatically propagates to all callers.
///
/// On Android emulators, `10.0.2.2` maps to the host machine's localhost.
/// On iOS simulators, use `127.0.0.1`.
/// Override [baseUrl] via a compile-time define for staging/production:
///   flutter run --dart-define=API_BASE_URL=https://api.example.com
abstract final class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  // ── Auth ──────────────────────────────────────────────────────
  static const String login = '/api/v1/auth/login';

  // ── Users ─────────────────────────────────────────────────────
  static const String users = '/api/v1/users';
  static String userById(int id) => '/api/v1/users/$id';

  // ── Warehouses ────────────────────────────────────────────────
  static const String warehouses = '/api/v1/warehouses';
  static String warehouseById(int id) => '/api/v1/warehouses/$id';

  // ── Locations ─────────────────────────────────────────────────
  static const String locations = '/api/v1/locations';
  static String locationById(int id) => '/api/v1/locations/$id';

  // ── Articles ──────────────────────────────────────────────────
  static const String articles = '/api/v1/articles';
  static String articleById(int id) => '/api/v1/articles/$id';

  // ── Inspections ───────────────────────────────────────────────
  static const String inspections = '/api/v1/inspections';
  static String inspectionById(int id) => '/api/v1/inspections/$id';
  static String inspectionStatus(int id) => '/api/v1/inspections/$id/status';

  // ── Damage Reports ────────────────────────────────────────────
  static const String damageReports = '/api/v1/damage-reports';
>>>>>>> 38d35ecc504df7aefda47e8dab5325df5dc5f1a1
  static String damageReportById(int id) => '/api/v1/damage-reports/$id';
}
