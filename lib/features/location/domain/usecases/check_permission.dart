import '../entities/permission_result.dart';
import '../repositories/location_repository.dart';

class CheckPermission {
  final LocationRepository repository;

  CheckPermission(this.repository);

  Future<PermissionResult> call() {
    return repository.checkPermission();
  }
}
