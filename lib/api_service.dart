import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://172.20.10.2:8070';

  Future<List<String>> getVideoPaths(String text) async {
    final url = Uri.parse('$baseUrl/videos/');
    print("url:-----------------------------------------------$url");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Data:=========================$data['video_paths']");
      return List<String>.from(data['video_paths']);
    } else {
      throw Exception('Failed to load videos');
    }
  }
}
