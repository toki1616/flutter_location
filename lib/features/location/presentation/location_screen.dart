// lib/features/location/presentation/test_location_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/location_providers.dart';

class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permission = ref.watch(permissionProvider);

    return permission.when(
      loading: () => const Scaffold(
        body: Center(child: Text('権限確認中…')),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('権限エラー: $e')),
      ),
      data: (result) {
        if (!result.granted) {
          return Scaffold(
            appBar: AppBar(title: const Text('Location Test')),
            body: Center(
              child: Text(result.message ?? '位置情報の権限がありません'),
            ),
          );
        }

        final location = ref.watch(locationStreamProvider);

        return Scaffold(
          appBar: AppBar(title: const Text('Location Test')),
          body: Center(
            child: location.when(
              loading: () => const Text('位置情報を取得中…'),
              error: (e, _) => Text('位置情報取得エラー: $e'),
              data: (loc) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('緯度: ${loc.latitude}'),
                  Text('経度: ${loc.longitude}'),
                  const SizedBox(height: 8),
                  Text('取得時刻: ${loc.timestamp}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}