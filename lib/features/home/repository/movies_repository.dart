import 'dart:convert';
import 'package:edstem_interview/core/constants/api_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../models/movies_model.dart';

final moviesRepositoryProvider = Provider(
      (ref) => MoviesRepository(),
);

class MoviesRepository {

// Function to fetch movies from the API based on a search query
  Future<List<MoviesModel>> getMovies(String search) async {
    try {
      if(search.isEmpty){
        return [];
      }
      // Define request headers
      var headers = {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYmUxYzAwZmJmZDRhODg4YTMxZjI2YTNmMWM2Y2YxYSIsIm5iZiI6MTc0OTI3NTc4Ny4yMDg5OTk5LCJzdWIiOiI2ODQzZDQ4YmI2MmRjMGYwMjYzMDBmNWEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.ZbX1xZNgqL5HycVTMZI9uclYF9Wz6CZTiPgzLK6vPB4'
      };
      print(1);
      print('${ApiConstants.getMovies}=$search');
      // Construct the request URL using the search query
      var request = http.Request('GET', Uri.parse('${ApiConstants.getMovies}=$search&api_key=${ApiConstants.apiKey}'));
      // Add headers to the request
      request.headers.addAll(headers);
      // Send the request and wait for the response
      http.StreamedResponse response = await request.send();
      print(2);
      print('STATUS CODE  ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> decodedList =  jsonDecode(await response.stream.bytesToString())['results'];
        if(decodedList.isEmpty){
          return [];
        }else{
          // Convert each result into a MoviesModel object and return the list
          return decodedList.map((e) => MoviesModel.fromJson(e)).toList();
        }

      }
      else {
        // If response failed, return an empty list
        return [];
      }

    } catch (e) {
      print(e.toString());
      // Catch and throw any exception encountered during the request
      throw Exception('Error fetching objects: $e');
    }
  }


}
