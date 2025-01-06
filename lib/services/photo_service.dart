import 'dart:convert';
import 'package:http/http.dart' as http;

class PhotoService {
  final String baseUrl = 'https://api.unsplash.com';
  final String accessKey = '7WZW_xymZFmCkothrXaWCvA0LMnsQd8civyMC2HsnXg';

  Future<List<String>> fetchPhotos(int page, int photosPerPage) async {
    final response = await http.get(
      Uri.parse('$baseUrl/photos?page=$page&per_page=$photosPerPage&client_id=$accessKey'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<String> photoUrls =
          data.map((item) => item['urls']['regular'].toString()).toList();
      return photoUrls;
    } else {
      throw Exception('Failed to load images');
    }
  }
  
}
