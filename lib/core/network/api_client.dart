import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final int timeoutSeconds;
  ApiClient({required this.baseUrl, this.timeoutSeconds = 30});

  Future<http.Response> postMultipart(String path, File image) async {
    final uri = Uri.parse('$baseUrl$path');
    final req = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final streamed = await req.send().timeout(Duration(seconds: timeoutSeconds));
    return http.Response.fromStream(streamed);
  }
}
