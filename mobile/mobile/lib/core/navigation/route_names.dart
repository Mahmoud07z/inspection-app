/// Named route path constants used throughout the app.
///
/// Using constants instead of raw strings prevents typos and enables
/// IDE-assisted refactoring. Every [GoRoute.path] and every [context.go()]
/// call must reference these — never use a raw string.
final class RouteNames {
  static const String login           = '/login';
  static const String dashboard       = '/';
  static const String warehouses      = '/warehouses';
  static const String warehouseDetail = '/warehouses/:id';
  static const String locations       = '/locations';
  static const String articles        = '/articles';
  static const String inspections     = '/inspections';
  static const String inspectionDetail = '/inspections/:id';
  static const String damageReports   = '/damage-reports';
  static const String users           = '/users';
}
