import '../entities/app_location.dart';
import '../repositories/location_repository.dart';

class GetLocationStream {
  final LocationRepository repository;

  GetLocationStream(this.repository);

  Stream<AppLocation> call() {
    return repository.getLocationStream();
  }
}
