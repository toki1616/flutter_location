import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_location.dart';
import '../../domain/entities/permission_result.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/check_permission.dart';
import '../../domain/usecases/get_location_stream.dart';
import '../../infrastructure/datasources/geolocator_datasource.dart';
import '../../infrastructure/repositories/location_repository_impl.dart';

/// DataSource
final geolocatorDataSourceProvider = Provider<GeolocatorDataSource>(
      (ref) => GeolocatorDataSource(),
);

/// Repository
final locationRepositoryProvider = Provider<LocationRepository>(
      (ref) => LocationRepositoryImpl(ref.read(geolocatorDataSourceProvider)),
);

/// UseCases
final checkPermissionUseCaseProvider = Provider<CheckPermission>(
      (ref) => CheckPermission(ref.read(locationRepositoryProvider)),
);

final getLocationStreamUseCaseProvider = Provider<GetLocationStream>(
      (ref) => GetLocationStream(ref.read(locationRepositoryProvider)),
);

/// Permission state
final permissionProvider = FutureProvider<PermissionResult>((ref) async {
  final usecase = ref.read(checkPermissionUseCaseProvider);
  return usecase();
});

/// Location stream state
final locationStreamProvider = StreamProvider<AppLocation>((ref) {
  final usecase = ref.read(getLocationStreamUseCaseProvider);
  return usecase();
});
