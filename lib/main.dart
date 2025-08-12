import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'core/network/api_client.dart';
import 'data/datasources/detection_remote_datasource.dart';
import 'data/repositories/detection_repository_impl.dart';
import 'domain/usecases/detect_balls.dart';
import 'presentation/bloc/detection_bloc.dart';
import 'presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final baseUrl = await _getBaseUrl();

  final api = ApiClient(baseUrl: baseUrl);
  final remote = DetectionRemoteDataSource(api);
  final repo = DetectionRepositoryImpl(remote);
  final usecase = DetectBalls(repo);

  runApp(MyApp(usecase: usecase));
}

Future<String> _getBaseUrl() async {
  final deviceInfo = DeviceInfoPlugin();
  final info = NetworkInfo();

  if (await _isEmulator(deviceInfo)) {
    // Android emulator
    return 'http://10.0.2.2:8000';
  } else {
    // Real device — get host LAN IP
    final ip = await info.getWifiGatewayIP() ?? '127.0.0.1';
    return 'http://$ip:8000';
  }
}

Future<bool> _isEmulator(DeviceInfoPlugin deviceInfo) async {
  try {
    final android = await deviceInfo.androidInfo;
    return !(android.isPhysicalDevice ?? true);
  } catch (_) {
    try {
      final ios = await deviceInfo.iosInfo;
      return !(ios.isPhysicalDevice ?? true);
    } catch (_) {
      return false; // Default to physical
    }
  }
}

class MyApp extends StatelessWidget {
  final DetectBalls usecase;

  const MyApp({super.key, required this.usecase});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CueZen',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => DetectionBloc(usecase),
        child: const HomePage(),
      ),
    );
  }
}
