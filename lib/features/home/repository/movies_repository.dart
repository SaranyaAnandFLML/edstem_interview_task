import 'dart:convert';
import 'package:edstem_interview/core/constants/api_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../models/movies_model.dart';

final moviesRepositoryProvider = Provider(
      (ref) => MoviesRepository(),
);

class MoviesRepository {

// Function to fetch movies from the API based on a search query
  Future<List<MoviesModel>> getMovies(String search) async {
    print(dotenv.env['API_KEY']!+"    kkk");
    String? token = dotenv.env['API_KEY'];
    try {
      if(search.isEmpty){
        return [];
      }
      // Define request headers
      var headers = {
        'Authorization': 'Bearer $token'
      };
      print(1);
      print('${ApiConstants.getMovies}=$search');
      // Construct the request URL using the search query
      var request = http.Request('GET', Uri.parse('${ApiConstants.getMovies}=$search&api_key=$token'));
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
