import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../models/movies_model.dart';

final moviesRepositoryProvider = Provider(
      (ref) => MoviesRepository(),
);

class MoviesRepository {

  Future<List<MoviesModel>> getMovies(String search) async {
    try {

      var headers = {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYmUxYzAwZmJmZDRhODg4YTMxZjI2YTNmMWM2Y2YxYSIsIm5iZiI6MTc0OTI3NTc4Ny4yMDg5OTk5LCJzdWIiOiI2ODQzZDQ4YmI2MmRjMGYwMjYzMDBmNWEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.ZbX1xZNgqL5HycVTMZI9uclYF9Wz6CZTiPgzLK6vPB4'
      };
      var request = http.Request('GET', Uri.parse('https://api.themoviedb.org/3/search/movie?query=$search'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        List<dynamic> decodedList =  jsonDecode(await response.stream.bytesToString())['results'];
              return decodedList.map((e) => MoviesModel.fromJson(e)).toList();
      }
      else {
        return [];
      }

    } catch (e) {
      throw Exception('Error fetching objects: $e');
    }
  }


}
