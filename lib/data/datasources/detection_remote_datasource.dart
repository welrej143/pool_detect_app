import 'dart:convert';
import 'dart:io';
import 'package:pool_detect_app/core/network/api_client.dart';
import 'package:pool_detect_app/data/models/detection_model.dart';

class DetectionRemoteDataSource {
  final ApiClient client;
  DetectionRemoteDataSource(this.client);

  Future<({List<DetectionModel> detections, int imageW, int imageH})> detect(File image) async {
    final resp = await client.postMultipart('/detect', image);
    if (resp.statusCode != 200) {
      throw Exception('Server error: ${resp.statusCode} ${resp.body}');
    }
    final map = jsonDecode(resp.body) as Map<String, dynamic>;
    final list = (map['detections'] as List<dynamic>)
        .map((e) => DetectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final w = map['w'] as int;
    final h = map['h'] as int;
    return (detections: list, imageW: w, imageH: h);
  }
}
