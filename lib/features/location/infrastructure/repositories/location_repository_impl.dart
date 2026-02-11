import 'package:geolocator/geolocator.dart';

import '../../domain/entities/app_location.dart';
import '../../domain/entities/permission_result.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/geolocator_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  final GeolocatorDataSource dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Future<PermissionResult> checkPermission() async {
    final serviceEnabled = await dataSource.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return PermissionResult(false, message: '位置情報サービスが無効です');
    }

    var permission = await dataSource.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await dataSource.requestPermission();
      if (permission == LocationPermission.denied) {
        return PermissionResult(false, message: '位置情報の権限が拒否されました');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return PermissionResult(false, message: '位置情報の権限が永久に拒否されています');
    }

    return PermissionResult(true);
  }

  @override
  Stream<AppLocation> getLocationStream() {
    return dataSource.getPositionStream().map(
          (Position pos) => AppLocation(
        latitude: pos.latitude,
        longitude: pos.longitude,
        timestamp: DateTime.now(),
      ),
    );
  }
}
