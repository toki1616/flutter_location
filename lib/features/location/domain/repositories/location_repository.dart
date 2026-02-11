import '../entities/app_location.dart';
import '../entities/permission_result.dart';

abstract class LocationRepository {
  Future<PermissionResult> checkPermission();
  Stream<AppLocation> getLocationStream();
}
