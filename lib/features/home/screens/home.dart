import 'package:cached_network_image/cached_network_image.dart';
import 'package:edstem_interview/core/common/error_text.dart';
import 'package:edstem_interview/core/common/loader.dart';
import 'package:edstem_interview/core/constants/asset_constants.dart';
import 'package:edstem_interview/pallette/pallette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../core/common/global_variables.dart';
import '../controller/movies_controller.dart';
import 'movie_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Controller for search input
  TextEditingController searchController = TextEditingController();

  // StateProvider to store search input value
  final searchInputProvider = StateProvider<String>((ref) => '');

  @override
  Widget build(BuildContext context) {
    // Getting screen height and width for responsive UI
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(w*0.28),
        child: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App title
                  Text(
                    'Movies',
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Pallete.whiteColor,
                    ),
                  ),
                  SizedBox(height: w*0.01),

                  // Search bar
                  Container(
                    height: w*0.1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Pallete.greyColor),
                        SizedBox(width: w*0.02),
                        // Search TextField
                        Expanded(
                          child: Consumer(
                            builder: (context, ref, _) {
                              final searchText = ref.watch(searchInputProvider);
                              final controller = searchController;

                              return TextField(
                                controller: searchController,
                                onChanged: (value) => ref.read(searchInputProvider.notifier).state = value,
                                decoration: InputDecoration(
                                  hintText: 'Search movie',
                                  border: InputBorder.none,
                                  suffixIcon: searchText.isNotEmpty
                                      ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      controller.clear();
                                      ref.read(searchInputProvider.notifier).state = '';
                                    },
                                  )
                                      : null,
                                ),

                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Body: Display movie list or loader/error
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final search = ref.watch(searchInputProvider); // Get search term
          final data = ref.watch(getMoviesProvider(search)); // Watch API state

          return data.when(
            // If data is received successfully
            data: (objects) {
              return objects.isEmpty
                  ? const Center(child: Text('NO DATA FOUND'))
                  : ListView.builder(
                itemCount: objects.length,
                itemBuilder: (context, index) {
                  final movie = objects[index];

                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MovieDetails(movie: movie,)));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Pallete.greyColor.shade300),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Movie Poster
                          Hero(
                            tag: 'moviePoster_${movie.id}', // unique tag for each movie
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                imageUrl: 'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                width: w * 0.25,
                                height: h * 0.15,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: w * 0.25,
                                  height: h * 0.15,
                                  color: Pallete.greyColor[200],
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: w * 0.25,
                                  height: h * 0.15,
                                  color: Pallete.greyColor[300],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: w*0.02,),
                          // Movie details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Movie title
                                Text(
                                  movie.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: w*0.01),

                                // Release date
                                Text(
                                  'Release: ${movie.releaseDate}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Pallete.greyColor[600],
                                  ),
                                ),
                                SizedBox(height: w*0.01),

                                // Language and vote count
                                Text(
                                  'Language: ${movie.originalLanguage.toUpperCase()} • Votes: ${movie.voteCount.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Pallete.greyColor[700],
                                  ),
                                ),
                                SizedBox(height: w*0.01),

                                // Star rating (voteAverage out of 10, converted to 5 stars)
                                Row(
                                  children: [
                                    ...List.generate(5, (index) {
                                      double rating = movie.voteAverage / 2;
                                      if (rating >= index + 1) {
                                        return const Icon(Icons.star, color: Colors.amber, size: 20);
                                      } else if (rating >= index + 0.5) {
                                        return const Icon(Icons.star_half, color: Colors.amber, size: 20);
                                      } else {
                                        return const Icon(Icons.star_border, color: Colors.amber, size: 20);
                                      }
                                    }),
                                  ]
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },

            // On error
            error: (error, stack) {
              if (kDebugMode) {
                // Show detailed error in debug mode
                print(error);
                return ErrorText(error: error.toString());
              } else {
                // Show a GIF (loading or error animation) in release mode
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        fit: BoxFit.contain,
                      AssetConstants.errorGif,
                        width: w*0.4,
                        height: w*0.2,
                        repeat: true,
                      ),
                      Text('Something went wrong!',style: TextStyle(color: Pallete.orangeColor,fontWeight: FontWeight.bold,fontSize: w*0.04),)
                    ],
                  ),
                );
              }
            },

            // While loading
            loading: () {
              return Loader();
            },
          );
        },
      ),
    );
  }
}
